import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';

class FetchAccountRecoveryUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result> run(String accountName) {
    return _guardiansRepository.getAccountGuardians(accountName);
  }
}
