import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class StopGuardianRecoveryUseCase {
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result> stopRecovery() {
    return _guardiansRepository.cancelGuardians().then((Result value) {
      if (value.isError) {
        // cancelGuardians fails if the user does not have guardians.
        // We dont want to fail, our purpose is to remove guardians, and if the user doesnt have guardians
        // then we succeeded. Thats why we return ValueResult if it fails with "does not have guards"
        if (value.asError!.error.toString().contains('does not have guards')) {
          return _onCancelGuardiansSuccess();
        } else {
          return value;
        }
      } else {
        return _onCancelGuardiansSuccess();
      }
    });
  }

  Future<Result> _onCancelGuardiansSuccess() {
    return _firebaseRepository
        .removeGuardiansInitialized(settingsStorage.accountName)
        .then((value) => ValueResult(true))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((onError) => ErrorResult(false));
  }
}
