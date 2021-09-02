import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class CancelRecoveryProcessUseCase extends AccountUseCase {
  void run() {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.cancelRecoveryProcess();
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}
