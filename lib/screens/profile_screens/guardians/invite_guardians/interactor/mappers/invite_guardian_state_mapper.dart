import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/viewmodels/invite_guardians_bloc.dart';

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
