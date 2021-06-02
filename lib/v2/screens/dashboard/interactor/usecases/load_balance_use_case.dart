import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';

export 'package:async/src/result/result.dart';

class LoadBalanceUseCase {
  Future<Result> run(TokenModel token) {
    var account = settingsStorage.accountName;
    return  BalanceRepository().getTokenBalance(account, token);
  }
}
