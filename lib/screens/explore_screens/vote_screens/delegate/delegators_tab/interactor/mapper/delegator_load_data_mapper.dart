import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_state.dart';

class DelegatorLoadDataStateMapper extends StateMapper {
  DelegatorState mapResultToState(DelegatorState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      if (result.asValue!.value is MemberModel) {
        final MemberModel delegateMember = result.asValue!.value as MemberModel;
        return currentState.copyWith(pageState: PageState.success, );
      } else {
        return currentState.copyWith(
          pageState: PageState.success,

        );
      }
    }
  }
}
