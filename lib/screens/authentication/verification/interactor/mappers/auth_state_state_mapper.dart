import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_state.dart';

class AuthStateStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        errorMessage: 'Error auth with biometrics: ${result.asError!.error}',
        authError: result.asError!.error.toString() == auth_error.notEnrolled,
      );
    } else {
      return currentState.copyWith(authState: result.asValue!.value);
    }
  }
}
