import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';

class RemoveGuardianStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Error Removing Guardian".i18n),
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowMessage("Success, Guardian removed".i18n),
      );
    }
  }
}
