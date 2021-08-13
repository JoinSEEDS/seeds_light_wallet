import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';
import 'package:seeds/v2/i18n/profile_screens/guardians/guardians.i18n.dart';

class InviteGuardiansStateMapper extends StateMapper {
  InviteGuardiansState mapResultToState(InviteGuardiansState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure,
          pageCommand: ShowErrorMessage('Oops, something went wrong. Please try again later'.i18n));
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: NavigateToRoute(Routes.inviteGuardiansSent),
      );
    }
  }
}
