import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';

class RemoveGuardianStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Error Removing Guardian"),
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowMessage("Success, Guardian removed"),
      );
    }
  }
}
