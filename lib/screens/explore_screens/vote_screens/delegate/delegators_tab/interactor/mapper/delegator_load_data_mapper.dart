import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_state.dart';

class DelegatorLoadDataStateMapper extends StateMapper {
  DelegatorState mapResultToState(DelegatorState currentState, List<Result>? results) {
    if (results == null) {
      return currentState.copyWith(pageState: PageState.failure);
    } else if (results.isEmpty) {
      return currentState.copyWith(
        pageState: PageState.success,
        delegators: [],
        hasDelegators: false,
      );
    } else {
      final List<MemberModel> delegators = [];

      for (int i = 0; i < results.length; i++) {
        delegators.add(results[i].asValue!.value as MemberModel);
      }

      return currentState.copyWith(
        pageState: PageState.success,
        delegators: delegators,
        hasDelegators: true,
      );
    }
  }
}
