import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_user_repository.dart';
import 'package:seeds/utils/string_extension.dart';

class CreateAccountUseCase {
  CreateAccountUseCase({
    required SignupRepository signupRepository,
    required FirebaseUserRepository firebaseUserRepository,
  })  : _signupRepository = signupRepository,
        _firebaseUserRepository = firebaseUserRepository;

  final SignupRepository _signupRepository;
  final FirebaseUserRepository _firebaseUserRepository;

  Future<Result> run({
    required String inviteSecret,
    required String displayName,
    required String username,
    required AuthDataModel authData,
    String? phoneNumber,
  }) async {
    final Result result = await _signupRepository.createAccount(
      accountName: username,
      inviteSecret: inviteSecret,
      displayName: displayName,
      privateKey: authData.eOSPrivateKey,
    );

    // Phone number is optional.
    if (result.isValue && !phoneNumber.isNullOrEmpty) {
      try {
        // Add phone number
        await _firebaseUserRepository.saveUserPhoneNumber(userId: username, phoneNumber: phoneNumber ?? '');
      } catch (error) {
        print('Failed to save the phone number: $error');
      }
    }

    return result;
  }
}
