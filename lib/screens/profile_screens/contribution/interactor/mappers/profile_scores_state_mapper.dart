import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/contribution_bloc.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:seeds/utils/result_extension.dart';

const int _contributionScoreResultIndex = 0;
const int _communityScoreResultIndex = 1;
const int _reputationScoreResultIndex = 2;
const int _plantedScoreResultIndex = 3;
const int _transactionScoreResultIndex = 4;

class ProfileScoresStateMapper extends StateMapper {
  ContributionState mapResultToState(ContributionState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      final score = ScoresViewModel(
        contributionScore: results[_contributionScoreResultIndex].valueOrNull as ScoreModel?,
        communityScore: results[_communityScoreResultIndex].valueOrNull as ScoreModel?,
        reputationScore: results[_reputationScoreResultIndex].valueOrNull as ScoreModel?,
        plantedScore: results[_plantedScoreResultIndex].valueOrNull as ScoreModel?,
        transactionScore: results[_transactionScoreResultIndex].valueOrNull as ScoreModel?,
      );

      return currentState.copyWith(pageState: PageState.success, score: score);
    }
  }
}
