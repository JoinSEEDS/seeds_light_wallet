import 'package:pedantic/pedantic.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_message_token_repository.dart';

abstract class AccountUseCase {
  Future<void> updateFirebaseToken({required String oldAccount, String newAccount = ""}) async {
    if (oldAccount != newAccount) {
      if (oldAccount.isNotEmpty) {
        await FirebaseMessageTokenRepository().removeFirebaseMessageToken(oldAccount);
      }
      if (newAccount.isNotEmpty) {
        await FirebaseMessageTokenRepository().setFirebaseMessageToken(newAccount);
      }
    }
  }
}

class SaveAccountUseCase extends AccountUseCase {
  void run(String accountName, String privateKey) {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.saveAccount(accountName, privateKey);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: accountName);
  }
}

class CancelRecoveryProcessUseCase extends AccountUseCase {
  void run() {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.cancelRecoveryProcess();
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}

class RemoveAccountUseCase extends AccountUseCase {
  Future<void> run() async {
    final String oldAccountName = settingsStorage.accountName;
    await settingsStorage.removeAccount();
    unawaited(updateFirebaseToken(oldAccount: oldAccountName));
  }
}
