import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

class ProfileValuesStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      print('ProfileValuesStateMapper mapResultsToState length=${results.length}');
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue.value).toList();
      ProfileModel profile = values.firstWhere((i) => i is ProfileModel, orElse: () => null);
      ScoreModel score = values.firstWhere((i) => i is ScoreModel, orElse: () => null);

      return currentState.copyWith(pageState: PageState.success, profile: profile, score: score);
    }
  }
}
