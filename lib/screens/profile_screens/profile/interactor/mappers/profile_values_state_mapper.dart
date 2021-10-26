import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/organization_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

class ProfileValuesStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      // results.retainWhere((Result i) => i.isValue); // seems like a bug if there's 1 bad result it will do the wrong thing
      final ProfileModel? profile = results[0].valueOrNull;
      final bool isCitizen = settingsStorage.isCitizen;
      final CitizenshipUpgradeStatus citizenshipUpgradeStatus;

      if (isCitizen) {
        final score = ScoresViewModel(
          contributionScore: results[1].valueOrNull,
          communityScore: results[2].valueOrNull,
          reputationScore: results[3].valueOrNull,
          plantedScore: results[4].valueOrNull,
          transactionScore: results[5].valueOrNull,
        );
        return currentState.copyWith(pageState: PageState.success, profile: profile, score: score);
      }

      final score = ScoresViewModel(
        contributionScore: results[1].valueOrNull,
        communityScore: results[2].valueOrNull,
        reputationScore: results[3].valueOrNull,
        plantedScore: results[4].valueOrNull,
        transactionScore: results[5].valueOrNull,
      );

      final organization = results[6].asValue?.value as List<OrganizationModel>;

      results[7].isValue
          ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canResident
          : results[8].isValue
              ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canCitizen
              : citizenshipUpgradeStatus = CitizenshipUpgradeStatus.notReady;

      return currentState.copyWith(
        pageState: PageState.success,
        profile: profile,
        score: score,
        isOrganization: organization.isNotEmpty,
        citizenshipUpgradeStatus: citizenshipUpgradeStatus,
      );
    }
  }
}

extension _ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
