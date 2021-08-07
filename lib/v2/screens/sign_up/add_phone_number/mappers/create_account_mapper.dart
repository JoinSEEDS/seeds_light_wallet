import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class CreateAccountMapper extends StateMapper {
  SignupState mapOnCreateAccountTappedToState(SignupState currentState, Result result) {
    final createUsernameState = currentState.createUsernameState;

    if (result.isError) {
      final newState = createUsernameState.copyWith(
          pageState: PageState.failure, errorMessage: 'Failed to create the account. Please try again later.');

      return currentState.copyWith(createUsernameState: newState);
    }

    return currentState.copyWith(createUsernameState: createUsernameState.copyWith(pageState: PageState.success));
  }
}
