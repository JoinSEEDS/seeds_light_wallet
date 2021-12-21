import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_bloc.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

class VouchForAMemberStateMapper extends StateMapper {
  VouchForAMemberState mapResultToState(VouchForAMemberState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error when vouching for a member");
    } else {
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowVouchForMemberSuccess());
    }
  }
}
