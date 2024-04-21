import 'package:collection/collection.dart';
import 'package:dynamic_parallel_queue/dynamic_parallel_queue.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/datasource/remote/api/stat_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/usecases/load_token_balances_use_case.dart';

class TokenModelSelector {
  final List<String> acceptList;
  final List<String>? infoList;

  const TokenModelSelector({
    required this.acceptList,
    this.infoList,
  });
}

/// Retrieve token metadata (used for display of currency cards etc) from
/// token master smart contract (tmastr.seeds) and build TokenModel objects
class GetTokenModelsUseCase extends InputUseCase<List<TokenModel>, TokenModelSelector> {
  @override
  Future<Result<List<TokenModel>>> run(TokenModelSelector input) async {
    print("[http] importing token models");
    final idSet = <int>{};
    final useCaseMap = <int, List<String>>{} ;
    /// accumulate accepted token id's in idSet
    /// record valid usecases (from both acceptList and infoList) for each token in useCaseMap
    for(final useCase in input.acceptList + (input.infoList ?? [])) {
      bool more = true;
      int lastRetrieved = -1;
      fetchOneUseCase:
      while(more) {
        final acceptedTokenIdsResult = await TokenModelsRepository()
            .getAcceptedTokenIds(useCase, lastRetrieved+1);
        if(acceptedTokenIdsResult.isError) {
          break fetchOneUseCase;
        }
        final resultValue = acceptedTokenIdsResult.asValue!.value;
        more = resultValue['more'];
        final acceptances = resultValue['rows'].toList();
        final tokenIds = List<int>.from(
            acceptances.map((row) => row['token_id']).toList());
        if(tokenIds.isEmpty) {
          continue;
        }
        for (final id in tokenIds) {
          useCaseMap[id] ??= [];
          useCaseMap[id]!.add(useCase);
        }
        if (input.acceptList.contains(useCase)) {
          idSet.addAll(tokenIds);
        }
        lastRetrieved = tokenIds.last;
      }
    }

    final List<int> remainingIds = idSet.toList();
    remainingIds.sort();
    bool more = true;
    final rv = <TokenModel>[];
    while(more && remainingIds.isNotEmpty) {
      final allTokensResult = await TokenModelsRepository()
          .getMasterTokenTable(remainingIds[0]);
      if (allTokensResult.isError) {
        return Result.error("failed to get master token list");
      }
      final resultValue = allTokensResult.asValue!.value;
      more = resultValue["more"];
      final allTokenRows = resultValue["rows"];
      final tokens = allTokenRows.where((row) {
        final id = row["id"];
        if (remainingIds.contains(id)) {
          remainingIds.remove(id);
          return true;
        } else {
          return false;
        }
      }).toList();
      /// retrieve entire list of tokens from master list, then filter by idSet; paginate by "more"
      for (final token in tokens) {
        token['usecases'] = useCaseMap[token['id']];
      }
      final StatRepository _statRepository = StatRepository();
      List<TokenModel?> theseTokens = [];
      /// verify token contract on chain and get contract precision
      loadData(token) async {
        TokenModel? tm = TokenModel.fromJson(token as Map<String, dynamic>);
        if (tm != null) {
          await _statRepository
            .getTokenStat(tokenContract: tm.contract, symbol: tm.symbol)
            .then(
              (stats) async {
                if (stats.asValue != null) {
                  final supply = stats.asValue!.value.supplyString;
                  tm.setPrecisionFromString(supply);
                  theseTokens.add(tm);
                  print("supply: $supply");
                }
              },
            ).catchError((dynamic error) => _statRepository.mapHttpError(error));
        }
      }
      final queue = Queue(parallel: 5);
      for (final dynamic token in tokens) {
        queue.add(() async {
          await loadData(token);
        });
      }
      await queue.whenComplete();
      rv.addAll(theseTokens.whereNotNull());
          /// build a TokenModel from each selected token's metadata
    }
    return Result.value(rv);
  }

}
