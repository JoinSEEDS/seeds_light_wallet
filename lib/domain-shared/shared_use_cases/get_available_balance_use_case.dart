import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class GetAvailableBalanceUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();

  Future<Result> run(TokenParameters tokenParameters) {
    return _balanceRepository.getTokenBalance(
      settingsStorage.accountName,
      tokenContract: tokenParameters.contract,
      symbol: tokenParameters.symbol,
    );
  }
}
