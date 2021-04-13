import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/verification_state.dart';

class AuthStateStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(authState: result.asValue.value);
    }
  }
}
