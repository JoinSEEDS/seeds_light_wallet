import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetExploreUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();

  Future<Result> run(String accountName) {
    return _balanceRepository.getBalance(accountName);
  }
}
