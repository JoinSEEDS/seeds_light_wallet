import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';

class VerificationStatusStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        errorMessage: 'Error auth with biometrics: ${result.asError!.error}',
        authErrorCode: result.asError!.error.toString() == auth_error.notEnrolled,
      );
    } else {
      return currentState.copyWith(biometricAuthStatus: result.asValue!.value);
    }
  }
}
