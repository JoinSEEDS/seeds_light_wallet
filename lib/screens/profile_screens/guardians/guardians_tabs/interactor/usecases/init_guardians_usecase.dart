import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

class InitGuardiansUseCase {
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<dynamic>> initGuardians(Iterable<GuardianModel> myGuardians) {
    return _guardiansRepository.setGuardianPermission().then((Result value) {
      if (value.isError) {
        return value;
      } else {
        return _guardiansRepository.initGuardians(myGuardians.map((e) => e.uid).toList()).then((Result value) {
          if (value.isError) {
            return value;
          } else {
            return _firebaseRepository.setGuardiansInitialized(settingsStorage.accountName);
          }
        });
      }
    });
  }
}
