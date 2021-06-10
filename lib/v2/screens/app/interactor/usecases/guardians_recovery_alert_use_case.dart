import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_user_repository.dart';

class RecoveryAlertUseCase {
  Stream<bool> get shouldShowCancelGuardianAlertMessage {
    return FirebaseUserRepository()
        .getUserData(settingsStorage.accountName)
        .asyncMap((event) => event.guardianRecoveryStarted != null);
  }
}
