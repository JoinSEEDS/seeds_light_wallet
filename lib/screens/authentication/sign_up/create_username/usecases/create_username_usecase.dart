import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/screens/authentication/sign_up/create_username/mappers/create_username_mapper.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/bloc.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/states/create_username_state.dart';
import 'package:seeds/utils/string_extension.dart';

class CreateUsernameUseCase {
  CreateUsernameUseCase({required SignupRepository signupRepository}) : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  Stream<SignupState> validateUsername(SignupState currentState, String username) async* {
    final validationError = _validateUsername(username);

    if (validationError == null) {
      yield currentState.copyWith(createUsernameState: CreateUsernameState.loading(currentState.createUsernameState));

      final Result result = await _signupRepository.isUsernameTaken(username);

      yield CreateUsernameMapper().mapValidateUsernameToState(currentState, username, result);
    } else {
      yield currentState.copyWith(
          createUsernameState: CreateUsernameState.error(currentState.createUsernameState, validationError));
    }
  }

  Stream<SignupState> generateNewUsername(SignupState currentState, String fullname) async* {
    yield CreateUsernameMapper().mapGenerateUsernameToState(currentState, fullname);
  }

  String? _validateUsername(String? username) {
    final validCharacters = RegExp(r'^[a-z1-5]+$');

    if (username.isNullOrEmpty) {
      return 'Please select a username';
      // ignore: unnecessary_raw_strings
    } else if (RegExp(r'0|6|7|8|9').allMatches(username!).isNotEmpty) {
      return 'Only numbers 1-5 can be used.';
    } else if (username.toLowerCase() != username) {
      return "Name can be lowercase only";
    } else if (!validCharacters.hasMatch(username) || username.contains(' ')) {
      return "No special characters or spaces can be used";
    } else if (username.length != 12) {
      return 'Username must be 12 characters long';
    }

    return null;
  }
}
