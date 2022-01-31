import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up/signup_errors.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';

class CreateAccountStateMapper extends StateMapper {
  SignupState mapResultToState(SignupState currentState, Result result, AuthDataModel authData) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: SignUpError.failedToCreateAccount);
    } else {
      return currentState.copyWith(pageCommand: OnAccountCreated(authData));
    }
  }
}
