import 'package:seeds/datasource/local/biometrics_service.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';

class VerificationStatusStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: 'Error auth with biometrics: ${result.asError!.error}',
        biometricAuthError: true,
      );
    } else {
      final BiometricAuthStatus biometricAuthStatus = result.asValue!.value as BiometricAuthStatus;
      if (biometricAuthStatus == BiometricAuthStatus.authorized) {
        return currentState.copyWith(pageCommand: BiometricAuthorized());
      } else {
        return currentState.copyWith(pageState: PageState.success, biometricAuthStatus: result.asValue!.value as BiometricAuthStatus?);
      }
    }
  }
}
