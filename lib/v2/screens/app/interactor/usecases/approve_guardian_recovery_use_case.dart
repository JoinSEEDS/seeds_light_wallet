import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';

class ApproveGuardianRecoveryUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result> approveGuardianRecovery(String userAccount, String publicKey) {
    return _guardiansRepository.recoverAccount(userAccount, publicKey);
  }
}
