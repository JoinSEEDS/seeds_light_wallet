import 'package:collection/collection.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class TokenModelSelector {
  final List<String> acceptList;
  final List<String>? infoList;

  const TokenModelSelector({
    required this.acceptList,
    this.infoList,
  });
}

class GetTokenModelsUseCase extends InputUseCase<List<TokenModel>, TokenModelSelector> {
  @override
  Future<Result<List<TokenModel>>> run(TokenModelSelector input) async {
    print("[http] importing token models");
    final idSet = <int>{};
    final useCaseMap = <int, List<String>>{} ;
    /// accumulate accepted token id's in idSet
    /// record valid usecases (from both acceptList and infoList) for each token in useCaseMap
    for(final useCase in input.acceptList + (input.infoList ?? [])) {
      final tokenIdsResult = await TokenModelsRepository().getAcceptedTokenIds(useCase);
      if(tokenIdsResult.isError) {
        continue;
      }
      final tokenIds = tokenIdsResult.asValue!.value;
      for (final id in tokenIds) {
        useCaseMap[id] ??= [];
        useCaseMap[id]!.add(useCase);
      }
      if(input.acceptList.contains(useCase)) {
        idSet.addAll(tokenIds);
      }
    }

    final allTokensResult = await TokenModelsRepository().getMasterTokenTable();
    if(allTokensResult.isError) {
      return Result.error("failed to get master token list");
    }
    final allTokens = allTokensResult.asValue!.value["rows"];
    final tokens = allTokens.where((row) => idSet.contains(row['id']));
    /// retrieve entire list of tokens from master list, then filter by idSet
    for (final token in tokens) {
      token['usecases'] = useCaseMap[token['id']];
    }
    return Result.value(List<TokenModel?>.from(tokens.map((token) =>
      TokenModel.fromJson(token))).whereNotNull().toList());
      /// build a TokenModel from each selected token's metadata

  }

}
