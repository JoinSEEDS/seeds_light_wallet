import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/organization_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

const int _profileResultIndex = 0;
const int _contributionScoreResultIndex = 1;
const int _organizationResultIndex = 2;
const int _canResidentResultIndex = 3;
const int _canCitizenResultIndex = 4;

class ProfileValuesStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      // results.retainWhere((Result i) => i.isValue); // seems like a bug if there's 1 bad result it will do the wrong thing
      final ProfileModel? profile = results[_profileResultIndex].valueOrNull;
      final bool isCitizen = settingsStorage.isCitizen;
      final CitizenshipUpgradeStatus citizenshipUpgradeStatus;

      if (isCitizen) {
        return currentState.copyWith(
            pageState: PageState.success,
            profile: profile,
            contributionScore: results[_contributionScoreResultIndex].valueOrNull);
      } else {
        final organization = results[_organizationResultIndex].asValue?.value as List<OrganizationModel>;

        results[_canResidentResultIndex].isValue
            ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canResident
            : results[_canCitizenResultIndex].isValue
                ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canCitizen
                : citizenshipUpgradeStatus = CitizenshipUpgradeStatus.notReady;

        return currentState.copyWith(
          pageState: PageState.success,
          profile: profile,
          contributionScore: results[_contributionScoreResultIndex].valueOrNull,
          isOrganization: organization.isNotEmpty,
          citizenshipUpgradeStatus: citizenshipUpgradeStatus,
        );
      }
    }
  }
}
