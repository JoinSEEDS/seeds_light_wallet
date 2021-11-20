import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/signup_bloc.dart';

class CreateAccountStateMapper extends StateMapper {
  SignupState mapResultToState(SignupState currentState, Result result, AuthDataModel authData) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: 'Failed to create the account. Please try again later.'.i18n,
      );
    } else {
      return currentState.copyWith(pageCommand: OnAccountCreated(authData));
    }
  }
}
