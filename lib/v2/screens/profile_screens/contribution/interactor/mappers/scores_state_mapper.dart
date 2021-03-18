import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/contribution_state.dart';

class ScoresStateMapper extends StateMapper {
  ContributionState mapResultToState(ContributionState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, score: result.asValue.value);
    }
  }
}
