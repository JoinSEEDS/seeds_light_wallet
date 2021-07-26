import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_state.dart';

class ApproveGuardianRecoveryStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure, pageCommand: ShowErrorMessage("Oops, something went wrong"));
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowMessage("Success, guardians recovery approved"),
        showGuardianApproveOrDenyScreen: null,
      );
    }
  }
}
