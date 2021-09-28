import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
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
    required EOSPrivateKey privateKey,
    String? phoneNumber,
  }) async {
    final Result result = await _signupRepository.createAccount(
      accountName: username,
      inviteSecret: inviteSecret,
      displayName: displayName,
      privateKey: privateKey,
    );

    // Phone number is optional.
    if (result.isValue && !phoneNumber.isNullOrEmpty) {
      try {
        // Add phone number
        await _firebaseUserRepository.saveUserPhoneNumber(username, phoneNumber);
      } catch (error) {
        print('Failed to save the phone number: $error');
      }
    }

    return result;
  }
}
