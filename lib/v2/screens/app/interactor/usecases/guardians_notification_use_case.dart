import 'package:seeds/v2/datasource/remote/api/guardians_notification_repository.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class GuardiansNotificationUseCase {
  Stream<bool> get hasGuardianNotificationPending {
    return GuardiansNotificationRepository().hasGuardianNotificationPending(settingsStorage.accountName);
  }
}
