import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class LoadTokenBalancesUseCase {
  Future<List<Result<BalanceModel>>> run(List<TokenModel> tokens) {
    final account = settingsStorage.accountName;
    final List<Future<Result<BalanceModel>>> list = tokens
        .map((item) => BalanceRepository().getTokenBalance(
              account,
              tokenContract: item.contract,
              symbol: item.symbol,
            ))
        .toList();
    return Future.wait(list);
  }
}
