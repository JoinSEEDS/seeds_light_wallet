import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/create_username_state.dart';

class CreateUsernameMapper extends StateMapper {
  SignupState mapValidateUsernameToState(SignupState currentState, Result result) {
    final createUsernameCurrentState = currentState.createUsernameState;

    if (result.isError) {
      // Error means username is not taken and is available for the user to take it
      final newState = createUsernameCurrentState.copyWith(
        pageState: PageState.success,
        pageCommand: null,
        errorMessage: null,
      );

      return currentState.copyWith(createUsernameState: newState);
    }

    // We got a success response which means username is taken, so we should ask user to pick another username
    return currentState.copyWith(
        createUsernameState: CreateUsernameState.error(createUsernameCurrentState, 'The username is already taken.'));
  }

  SignupState mapGenerateUsernameToState(SignupState currentState, String generatedUsername) {
    final createUsernameCurrentState = currentState.createUsernameState;

    final newState = createUsernameCurrentState.copyWith(
      pageCommand: UsernameGenerated(),
      username: generatedUsername,
    );

    return currentState.copyWith(createUsernameState: newState);
  }
}
