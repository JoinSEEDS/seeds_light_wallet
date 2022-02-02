import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up/signup_errors.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';

class SetAccountNameStateMapper extends StateMapper {
  SignupState mapResultToState(SignupState currentState, String accountName, Result result) {
    if (result.isError) {
      // Error means accountName is not taken and is available for the user to take it
      return currentState.copyWith(accountName: accountName, pageState: PageState.success);
    }
    // We got a success response which means username is taken, so we should ask user to pick another accountName
    return currentState.copyWith(pageState: PageState.failure, error: SignUpError.usernameAlreadyTaken);
  }
}
