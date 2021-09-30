import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class StartRecoveryUseCase extends AccountUseCase {
  void run({required String accountName, required AuthDataModel authData, required String recoveryLink}) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.enableRecoveryMode(accountName: accountName, authData: authData, recoveryLink: recoveryLink);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
