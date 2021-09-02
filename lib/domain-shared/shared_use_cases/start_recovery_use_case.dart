import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class StartRecoveryUseCase extends AccountUseCase {
  void run({required String accountName, required String privateKey}) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.saveAccountRecoveryMode(accountName: accountName, privateKey: privateKey);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
