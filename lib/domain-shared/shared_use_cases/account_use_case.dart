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
