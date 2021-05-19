import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';

class GetAvailableBalanceUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();

  Future<Result> run() {
    return _balanceRepository.getBalance(settingsStorage.accountName);
  }
}
