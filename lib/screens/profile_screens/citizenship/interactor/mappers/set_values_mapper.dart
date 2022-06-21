import 'dart:math';

import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/datasource/remote/model/seeds_history_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/citizenship/citizenship.i18n.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_bloc.dart';

class SetValuesStateMapper extends StateMapper {
  CitizenshipState mapResultToState(
    CitizenshipState currentState,
    List<Result> referredAccountResults,
    List<Result> citizenshipDataResults,
    Result<List<ProfileModel>>? vouchees,
  ) {
    // Accounts found, but errors fetching data happened.
    if (referredAccountResults.isNotEmpty && areAllResultsError(referredAccountResults)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts".i18n);
    } else if (areAllResultsError(citizenshipDataResults)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Citizenship Data'.i18n);
    } else if (vouchees != null && vouchees.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Citizenship Data'.i18n);
    } else {
      citizenshipDataResults.retainWhere((Result i) => i.isValue);
      final values = citizenshipDataResults.map((Result i) => i.asValue!.value).toList();

      final PlantedModel? plantedSeeds = values.firstWhere((i) => i is PlantedModel, orElse: () => null);
      final SeedsHistoryModel? seedsHistory = values.firstWhere((i) => i is SeedsHistoryModel, orElse: () => null);
      final ScoreModel? reputationScore = values.firstWhere((i) => i is ScoreModel, orElse: () => null);

      final int planted = plantedSeeds?.quantity.toInt() ?? 0;
      final int transactions = seedsHistory?.totalNumberOfTransactions ?? 0;

      double timeline = 0;
      final ProfileModel profile = currentState.profile!;
      final List<ProfileModel> profiles = referredAccountResults.map((i) => i.asValue!.value as ProfileModel).toList();

      final int reputation = reputationScore?.value ?? 0;

      int citizenVouched = 0;

      // Define timeline
      if (profile.status == ProfileStatus.visitor) {
        // Timeline to resident
        timeline = ((min(reputation, residentRequiredReputation) / residentRequiredReputation) +
                (min(profiles.length, residentRequiredVisitorsInvited) / residentRequiredVisitorsInvited) +
                (min(planted, residentRequiredPlantedSeeds) / residentRequiredPlantedSeeds) +
                (min(transactions, residentRequiredSeedsTransactions) / residentRequiredSeedsTransactions)) /
            4 *
            100;
      } else {
        final voucheesProfiles = vouchees!.asValue!.value;
        citizenVouched = voucheesProfiles.where((i) => i.status == ProfileStatus.citizen).length;
        // Timeline to citizen

        timeline = ((min(reputation, citizenRequiredReputation) / citizenRequiredReputation) +
                (min(planted, citizenRequiredPlantedSeeds) / citizenRequiredPlantedSeeds) +
                (min(transactions, citizenRequiredSeedsTransactions) / citizenRequiredSeedsTransactions) +
                (min(citizenVouched, citizenRequiredCitizenVouched) / citizenRequiredCitizenVouched) +
                (min(profile.accountAge, citizenRequiredAccountAge) / citizenRequiredAccountAge) +
                (min(profiles.length, citizenRequiredVisitorsInvited) / citizenRequiredVisitorsInvited)) /
            6 *
            100;
      }

      return currentState.copyWith(
        pageState: PageState.success,
        reputationScore: reputationScore,
        plantedSeeds: plantedSeeds?.quantity,
        seedsTransactionsCount: seedsHistory?.totalNumberOfTransactions,
        progressTimeline: timeline,
        invitedVisitors: profiles.length,
        citizenCeremony: citizenVouched,
      );
    }
  }
}
