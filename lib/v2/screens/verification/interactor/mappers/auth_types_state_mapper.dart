import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/verification_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';

class AuthTypesStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(
        authTypesAvailable: result.asValue.value,
        preferred: result.asValue.value.isEmpty ? AuthType.nothing : result.asValue.value[0],
      );
    }
  }
}
