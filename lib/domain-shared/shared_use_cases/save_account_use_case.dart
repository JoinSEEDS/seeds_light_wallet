import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class SaveAccountUseCase extends AccountUseCase {
  Future<void> run({required String accountName, required AuthDataModel authData}) async {
    final String oldAccountName = settingsStorage.accountName;
    await settingsStorage.saveAccount(accountName, authData);
    await updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
