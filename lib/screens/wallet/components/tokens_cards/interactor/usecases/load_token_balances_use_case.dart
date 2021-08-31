import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class LoadTokenBalancesUseCase {
  Future<List<Result>> run(List<TokenModel> tokens) {
    final account = settingsStorage.accountName;
    final List<Future<Result<dynamic>>> list = List.of(tokens.map((item) => BalanceRepository().getTokenBalance(
          account,
          tokenContract: item.contract,
          symbol: item.symbol,
        )));
    return Future.wait(list);
  }
}
