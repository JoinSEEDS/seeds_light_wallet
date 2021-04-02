import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';

class SendTransactionStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: result.asError.error.toString());
    } else {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: NavigateToTransactionSuccess(result.asValue.value.toString()));
    }
  }
}
