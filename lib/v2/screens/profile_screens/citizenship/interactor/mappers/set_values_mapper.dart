import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_state.dart';

class SetValuesStateMapper extends StateMapper {
  CitizenshipState mapResultToState(CitizenshipState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      double timeline = 0;
      ProfileModel profile = currentState.profile!;
      ScoreModel score = currentState.score!;
      List<ProfileModel> profiles = result.asValue?.value as List<ProfileModel>;

      // Define timeline
      if (profile.status == ProfileStatus.visitor) {
        // Timeline to resident
        // If the scores are greater than those required, use the required ones instead to avoid errors in the formula.
        int reputation =
            score.reputationScore > resident_required_reputation ? resident_required_reputation : score.reputationScore;
        int visitors = profiles.isNotEmpty ? resident_required_visitors_invited : 0;
        int planted =
            score.plantedScore > resident_required_planted_seeds ? resident_required_planted_seeds : score.plantedScore;
        int transactions = score.transactionsScore > resident_required_seeds_transactions
            ? resident_required_seeds_transactions
            : score.transactionsScore;

        // Timeline to resident formula
        timeline = ((reputation / resident_required_reputation) +
                (visitors / resident_required_visitors_invited) +
                (planted / resident_required_planted_seeds) +
                (transactions / resident_required_seeds_transactions)) /
            4 *
            100;
      } else {
        // Timeline to citizen
        // If the scores are greater than those required, use the required ones instead to avoid errors in the formula.
        int reputation =
            score.reputationScore > citizen_required_reputation ? citizen_required_reputation : score.reputationScore;
        int residents =
            profiles.where((i) => i.status == ProfileStatus.resident).length > citizen_required_residents_invited
                ? citizen_required_residents_invited
                : profiles.where((i) => i.status == ProfileStatus.resident).length;
        int age = profile.accountAge > citizen_required_account_age ? citizen_required_account_age : profile.accountAge;
        int planted =
            score.plantedScore > resident_required_planted_seeds ? resident_required_planted_seeds : score.plantedScore;
        int transactions = score.transactionsScore > resident_required_seeds_transactions
            ? resident_required_seeds_transactions
            : score.transactionsScore;
        int visitors =
            profiles.where((i) => i.status == ProfileStatus.visitor).length > citizen_required_visitors_invited
                ? citizen_required_visitors_invited
                : profiles.where((i) => i.status == ProfileStatus.visitor).length;

        // Timeline to citizen formula
        timeline = ((reputation / citizen_required_reputation) +
                (residents / citizen_required_residents_invited) +
                (age / citizen_required_account_age) +
                (planted / citizen_required_planted_seeds) +
                (transactions / citizen_required_seeds_transactions) +
                (visitors / citizen_required_visitors_invited)) /
            6 *
            100;
      }

      return currentState.copyWith(
        pageState: PageState.success,
        progressTimeline: timeline,
        invitedVisitors: profiles.where((i) => i.status == ProfileStatus.visitor).length,
        invitedResidents: profiles.where((i) => i.status == ProfileStatus.resident).length,
      );
    }
  }
}
