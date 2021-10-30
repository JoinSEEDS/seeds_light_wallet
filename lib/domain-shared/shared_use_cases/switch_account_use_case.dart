import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class SwitchAccountUseCase extends AccountUseCase {
  void run(String accountName, AuthDataModel authData) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.switchAccount(accountName, authData);
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
