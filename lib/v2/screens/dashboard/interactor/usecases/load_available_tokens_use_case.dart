import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';

export 'package:async/src/result/result.dart';

class LoadAvailableTokensUseCase {
  Future<List<Result>> run(List<TokenModel> tokens) {
    var account = settingsStorage.accountName;
    return BalanceRepository().getTokenBalances(account, tokens);
  }
}
