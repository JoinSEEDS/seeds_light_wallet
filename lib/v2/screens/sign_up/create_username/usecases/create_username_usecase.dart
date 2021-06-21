import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/screens/sign_up/create_username/mappers/create_username_mapper.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/create_username_state.dart';

class CreateUsernameUseCase {
  CreateUsernameUseCase({required SignupRepository signupRepository}) : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  Stream<SignupState> validateUsername(SignupState currentState, String username) async* {
    yield currentState.copyWith(createUsernameState: CreateUsernameState.loading(currentState.createUsernameState));

    final Result result = await _signupRepository.isUsernameTaken(username);

    yield CreateUsernameMapper().mapValidateUsernameToState(currentState, result);
  }

  Stream<SignupState> generateNewUsername(SignupState currentState, String fullname) async* {
    final String generatedUsername = _signupRepository.generateUsername(fullname);

    yield CreateUsernameMapper().mapGenerateUsernameToState(currentState, generatedUsername);
  }
}
