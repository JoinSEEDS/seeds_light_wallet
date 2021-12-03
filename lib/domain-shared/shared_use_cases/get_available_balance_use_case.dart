import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class GetAvailableBalanceUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();

  Future<Result<BalanceModel>> run(TokenModel token) {
    return _balanceRepository.getTokenBalance(
      settingsStorage.accountName,
      tokenContract: token.contract,
      symbol: token.symbol,
    );
  }
}
