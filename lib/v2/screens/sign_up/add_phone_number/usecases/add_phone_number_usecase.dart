import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_user_repository.dart';

class AddPhoneNumberUseCase {
  AddPhoneNumberUseCase({
    required SignupRepository signupRepository,
    required FirebaseUserRepository firebaseUserRepository,
  })  : _signupRepository = signupRepository,
        _firebaseUserRepository = firebaseUserRepository;

  final SignupRepository _signupRepository;
  final FirebaseUserRepository _firebaseUserRepository;

  Future<Result> run(
      {required String inviteSecret,
      required String displayName,
      required String username,
      String? phoneNumber}) async {
    final Result result = await _signupRepository.createAccount(
        accountName: username, inviteSecret: inviteSecret, displayName: displayName);

    if (result.isValue) {
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
