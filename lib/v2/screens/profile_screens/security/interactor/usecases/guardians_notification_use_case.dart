import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class GuardiansNotificationUseCase {
  Stream<bool> get hasGuardianNotificationPending {
    return FirebaseDatabaseService().hasGuardianNotificationPending(settingsStorage.accountName);
  }
}
