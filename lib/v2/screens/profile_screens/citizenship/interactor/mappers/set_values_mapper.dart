import 'dart:math';

import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_state.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

class SetValuesStateMapper extends StateMapper {
  CitizenshipState mapResultToState(CitizenshipState currentState, List<Result> results) {
    // Accounts found, but errors fetching data happened.
    if (areAllResultsError(results) && results.isNotEmpty) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts");
    } else {
      double timeline = 0;
      ProfileModel profile = currentState.profile!;
      ScoresViewModel score = currentState.score!;
      List<ProfileModel> profiles = results.map((i) => i.asValue!.value as ProfileModel).toList();

      // Define timeline
      if (profile.status == ProfileStatus.visitor) {
        // Timeline to resident
        // If the scores are greater than those required, use the required ones instead to avoid errors in the formula.
        int reputation = min(score.reputationScore?.value ?? 0, resident_required_reputation);
        int visitors = profiles.isNotEmpty ? resident_required_visitors_invited : 0;
        int planted = min(score.plantedScore?.value ?? 0, resident_required_planted_seeds);
        int transactions = min(score.transactionScore?.value ?? 0, resident_required_seeds_transactions);
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
        int reputation = min(score.reputationScore?.value ?? 0, citizen_required_reputation);
        int planted = min(score.plantedScore?.value ?? 0, citizen_required_planted_seeds);
        int transactions = min(score.transactionScore?.value ?? 0, citizen_required_seeds_transactions);
        int residents =
            profiles.where((i) => i.status == ProfileStatus.resident).length > citizen_required_residents_invited
                ? citizen_required_residents_invited
                : profiles.where((i) => i.status == ProfileStatus.resident).length;
        int visitors =
            profiles.where((i) => i.status == ProfileStatus.visitor).length > citizen_required_visitors_invited
                ? citizen_required_visitors_invited
                : profiles.where((i) => i.status == ProfileStatus.visitor).length;
        int age = min(profile.accountAge, citizen_required_account_age);

        // Timeline to citizen formula
        timeline = ((reputation / citizen_required_reputation) +
                (planted / citizen_required_planted_seeds) +
                (transactions / citizen_required_seeds_transactions) +
                (residents / citizen_required_residents_invited) +
                (age / citizen_required_account_age) +
                (visitors / citizen_required_visitors_invited)) /
            6 *
            100;
      }

      return currentState.copyWith(
        pageState: PageState.success,
        progressTimeline: timeline,
        invitedVisitors: profiles.where((i) => i.status == ProfileStatus.visitor).length,
        invitedResidents: profiles.where((i) => i.status == ProfileStatus.citizen || i.status == ProfileStatus.resident).length,
      );
    }
  }
}
