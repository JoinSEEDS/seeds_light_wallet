import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';

export 'package:async/src/result/result.dart';

class LoadTokenBalancesUseCase {
  Future<List<Result>> run(List<TokenModel> tokens) {
    var account = settingsStorage.accountName;
    List<Future<Result<dynamic>>> list =
        List.of(tokens.map((item) => BalanceRepository().getTokenBalance(account, item)));
    return Future.wait(list);
  }
}
