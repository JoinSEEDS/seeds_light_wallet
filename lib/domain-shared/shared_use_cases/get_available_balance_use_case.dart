import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class GetAvailableBalanceUseCase {
  final TokenModel token;
  final BalanceRepository _balanceRepository = BalanceRepository();

  GetAvailableBalanceUseCase(this.token);

  Future<Result> run() {
    return _balanceRepository.getTokenBalance(settingsStorage.accountName, token);
  }
}
