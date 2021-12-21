import 'package:async/async.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_user_repository.dart';
import 'package:seeds/utils/string_extension.dart';

class CreateAccountUseCase {
  Future<Result> run({
    required String inviteSecret,
    required String displayName,
    required String accountName,
    required AuthDataModel authData,
    String? phoneNumber,
  }) async {
    final Result result = await SignupRepository().createAccount(
      accountName: accountName,
      inviteSecret: inviteSecret,
      displayName: displayName,
      privateKey: authData.eOSPrivateKey,
    );

    // Phone number is optional.
    if (result.isValue && !phoneNumber.isNullOrEmpty) {
      try {
        // Add phone number
        await FirebaseUserRepository().saveUserPhoneNumber(userId: accountName, phoneNumber: phoneNumber ?? '');
      } catch (error) {
        print('Failed to save the phone number: $error');
      }
    }

    return result;
  }
}
