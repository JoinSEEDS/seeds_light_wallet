import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_bloc.dart';

class GetUserCitizenshipStatusStateMapper extends StateMapper {
  VouchedState mapResultToState(VouchedState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue!.value);
    }
  }
}
