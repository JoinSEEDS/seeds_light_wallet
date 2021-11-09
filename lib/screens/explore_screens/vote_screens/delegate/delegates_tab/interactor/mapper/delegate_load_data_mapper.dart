import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_state.dart';

class DelegateLoadDataStateMapper extends StateMapper {
  DelegateState mapResultToState(DelegateState currentState, Result? result) {
    if (result == null) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      if (result.asValue!.value is MemberModel) {
        final MemberModel delegateMember = result.asValue!.value as MemberModel;
        return currentState.copyWith(pageState: PageState.success, activeDelegate: true, delegate: delegateMember);
      } else {
        return currentState.copyWith(
          pageState: PageState.success,
          activeDelegate: false,
        );
      }
    }
  }
}
