import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegators_bloc.dart';

class LoadDelegatorsDataStateMapper extends StateMapper {
  DelegatorsState mapResultToState(DelegatorsState currentState, List<Result> results) {
    if (results.isNotEmpty && areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final List<Result> resultss = [];
      final List<MemberModel> delegators =
          resultss.map((i) => i.asValue!.value as MemberModel?).whereType<MemberModel>().toList();

      return currentState.copyWith(pageState: PageState.success, delegators: delegators);
    }
  }
}
