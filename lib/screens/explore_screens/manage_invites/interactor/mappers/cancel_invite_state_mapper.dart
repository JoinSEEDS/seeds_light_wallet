import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

class CancelInviteStateMapper extends StateMapper {
  ManageInvitesState mapResultToState(ManageInvitesState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Oops, something went wrong"),
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowMessage("Invite Canceled"),
      );
    }
  }
}
