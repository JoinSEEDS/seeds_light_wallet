import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class SaveAccountUseCase extends AccountUseCase {
  void run({required String accountName, required AuthDataModel authData}) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.saveAccount(accountName, authData);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
