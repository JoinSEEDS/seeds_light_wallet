import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class ApproveGuardianRecoveryUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final FirebaseDatabaseGuardiansRepository _databaseGuardiansRepository = FirebaseDatabaseGuardiansRepository();

  Future<Result> approveGuardianRecovery(String userAccount, String publicKey) async {
    final result = await _guardiansRepository.recoverAccount(userAccount, publicKey);

    // If recover call success, Init the firebase recovery flag.
    if (result.isValue) {
      await _databaseGuardiansRepository.setGuardianRecoveryStarted(userAccount);
    }

    return result;
  }
}
