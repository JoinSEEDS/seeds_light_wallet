import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_state.dart';

class AuthStateStateMapper extends StateMapper {
  AuthenticationState mapResultToState(AuthenticationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(authState: result.asValue.value);
    }
  }
}
