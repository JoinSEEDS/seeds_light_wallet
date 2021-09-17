import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class StartRecoveryUseCase extends AccountUseCase {
  void run({required String accountName, required String privateKey, required String recoveryLink}) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.enableRecoveryMode(accountName: accountName, privateKey: privateKey, recoveryLink: recoveryLink);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
