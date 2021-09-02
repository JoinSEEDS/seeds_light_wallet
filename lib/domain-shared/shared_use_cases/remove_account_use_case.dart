import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class RemoveAccountUseCase extends AccountUseCase {
  Future<void> run() async {
    final String oldAccountName = settingsStorage.accountName;
    await settingsStorage.removeAccount();
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}
