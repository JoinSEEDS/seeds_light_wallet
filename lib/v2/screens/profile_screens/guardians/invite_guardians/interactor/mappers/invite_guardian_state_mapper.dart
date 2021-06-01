import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_page_commands.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';

class InviteGuardiansStateMapper extends StateMapper {
  InviteGuardiansState mapResultToState(InviteGuardiansState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure,
          pageCommand: ShowErrorMessage('Oops, something went wrong. Please try again later'));
    } else {
      return currentState.copyWith(pageState: PageState.success, pageCommand: NavigateToGuardians());
    }
  }
}
