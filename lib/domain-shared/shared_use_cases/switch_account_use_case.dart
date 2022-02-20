import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class SwitchAccountUseCase extends AccountUseCase {
  Future<void> run(String accountName, AuthDataModel authData) async {
    final String oldAccountName = settingsStorage.accountName;
    await settingsStorage.switchAccount(accountName, authData);
    await const CacheRepository().clear();
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}
