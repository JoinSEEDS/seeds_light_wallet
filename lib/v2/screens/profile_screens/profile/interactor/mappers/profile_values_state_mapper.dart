import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

class ProfileValuesStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      // results.retainWhere((Result i) => i.isValue); // seems like a bug if there's 1 bad result it will do the wrong thing
      ProfileModel? profile = results[0].valueOrNull;
      var score = ScoresViewModel(
        contributionScore: results[1].valueOrNull,
        communityScore: results[2].valueOrNull,
        reputationScore: results[3].valueOrNull,
        plantedScore: results[4].valueOrNull,
        transactionScore: results[5].valueOrNull,
      );
      return currentState.copyWith(pageState: PageState.success, profile: profile, score: score);
    }
  }
}

extension ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
