import 'dart:math';

import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/seeds_history_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_state.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:seeds/v2/i18n/app/app.i18.dart';

class SetValuesStateMapper extends StateMapper {
  CitizenshipState mapResultToState(CitizenshipState currentState, List<Result> referredAccountResults, List<Result> citizenshipDataResults ) {
    // Accounts found, but errors fetching data happened.
    if (referredAccountResults.isNotEmpty && areAllResultsError(referredAccountResults)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts".i18n);
    } else if (areAllResultsError(citizenshipDataResults)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Citizenship Data'.i18n);
    } else {

      citizenshipDataResults.retainWhere((Result i) => i.isValue);
      var values = citizenshipDataResults.map((Result i) => i.asValue!.value).toList();

      PlantedModel? plantedSeeds = values.firstWhere((i) => i is PlantedModel, orElse: () => null);
      SeedsHistoryModel? seedsHistory = values.firstWhere((i) => i is SeedsHistoryModel, orElse: () => null);

      int planted = plantedSeeds?.quantity.toInt() ?? 0;
      int transactions = seedsHistory?.totalNumberOfTransactions ?? 0;

      double timeline = 0;
      ProfileModel profile = currentState.profile!;
      ScoresViewModel score = currentState.score!;
      List<ProfileModel> profiles = referredAccountResults.map((i) => i.asValue!.value as ProfileModel).toList();

      int reputation = score.reputationScore?.value ?? 0;

      // Define timeline
      if (profile.status == ProfileStatus.visitor) {
        // Timeline to resident
        timeline = ((min(reputation, resident_required_reputation) / resident_required_reputation) +
                (min(profiles.length, resident_required_visitors_invited) / resident_required_visitors_invited) +
                (min(planted, resident_required_planted_seeds) / resident_required_planted_seeds) +
                (min(transactions, resident_required_seeds_transactions) / resident_required_seeds_transactions)) /
            4 *
            100;
      } else {
        // Timeline to citizen
        int residentsInvited = profiles.where((i) => i.status == ProfileStatus.resident || i.status == ProfileStatus.citizen).length;
        timeline = ((min(reputation,citizen_required_reputation) / citizen_required_reputation) +
                (min(planted, citizen_required_planted_seeds) / citizen_required_planted_seeds) +
                (min(transactions, citizen_required_seeds_transactions) / citizen_required_seeds_transactions) +
                (min(residentsInvited, citizen_required_residents_invited) / citizen_required_residents_invited) +
                (min(profile.accountAge, citizen_required_account_age) / citizen_required_account_age) +
                (min(profiles.length, citizen_required_visitors_invited) / citizen_required_visitors_invited)) /
            6 *
            100;
      }

      return currentState.copyWith(
        pageState: PageState.success,
        plantedSeeds: plantedSeeds?.quantity,
        seedsTransactionsCount: seedsHistory?.totalNumberOfTransactions,
        progressTimeline: timeline,
        invitedVisitors: profiles.length,
        invitedResidents: profiles.where((i) => i.status == ProfileStatus.citizen || i.status == ProfileStatus.resident).length,
      );
    }
  }
}
