import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_type.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_state.dart';

class AuthTypesStateMapper extends StateMapper {
  VerificationState mapResultToState(VerificationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(errorMessage: result.asError!.error.toString());
    } else {
      return currentState.copyWith(
        authTypesAvailable: result.asValue!.value,
        preferred: result.asValue!.value.isEmpty ? AuthType.nothing : result.asValue!.value[0],
      );
    }
  }
}
