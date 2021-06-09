import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_state.dart';

class StopGuardianRecoveryStateMapper extends StateMapper {
  AppState mapResultToState(AppState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure,
          pageCommand: ShowStopGuardianRecoveryFailed("Oops, something went wrong"));
    } else {
      return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowStopGuardianRecoverySuccess("Success, guardians recovery stopped"));
    }
  }
}
