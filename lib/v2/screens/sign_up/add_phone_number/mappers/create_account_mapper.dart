import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class CreateAccountMapper extends StateMapper {
  SignupState mapOnCreateAccountTappedToState(SignupState currentState, Result result) {
    final addPhoneNumberState = currentState.addPhoneNumberState;

    if (result.isError) {
      final newState = addPhoneNumberState.copyWith(
          pageState: PageState.failure, errorMessage: 'Failed to create the account. Please try again later.');

      return currentState.copyWith(addPhoneNumberState: newState);
    }

    return currentState.copyWith(addPhoneNumberState: addPhoneNumberState.copyWith(pageState: PageState.success));
  }
}
