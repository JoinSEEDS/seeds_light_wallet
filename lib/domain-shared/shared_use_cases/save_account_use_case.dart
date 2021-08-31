import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_message_token_repository.dart';

abstract class AccountUseCase {
  Future<void> updateFirebaseToken({required String oldAccount, String newAccount = ""}) async {
    if (oldAccount != newAccount) {
      if (oldAccount.isNotEmpty) {
        print("removing message token for $oldAccount");
        await FirebaseMessageTokenRepository().removeFirebaseMessageToken(oldAccount);
      }
      if (newAccount.isNotEmpty) {
        print("adding message token for $oldAccount");
        await FirebaseMessageTokenRepository().setFirebaseMessageToken(newAccount);
      }
    }
  }
}

class SaveAccountUseCase extends AccountUseCase {
  void run(String accountName, String privateKey) {
    final String newAccountName = accountName;
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.saveAccount(accountName, privateKey);
    updateFirebaseToken(oldAccount: oldAccountName, newAccount: newAccountName);
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
  void run() {
    final String oldAccountName = settingsStorage.accountName;
    settingsStorage.removeAccount();
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}
