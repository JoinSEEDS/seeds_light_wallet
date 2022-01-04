import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/get_profile_values_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class ProfileValuesStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result<GetProfileValuesResponse> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      final response = result.asValue!.value;
      final bool isCitizen = settingsStorage.isCitizen;
      final CitizenshipUpgradeStatus citizenshipUpgradeStatus;

      if (isCitizen) {
        return currentState.copyWith(
            pageState: PageState.success, profile: response.profileModel, contributionScore: response.scoreModel);
      } else {
        final organization = response.organizationModel ?? [];

        response.canResident != null
            ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canResident
            : response.canCitizen != null
                ? citizenshipUpgradeStatus = CitizenshipUpgradeStatus.canCitizen
                : citizenshipUpgradeStatus = CitizenshipUpgradeStatus.notReady;

        return currentState.copyWith(
          pageState: PageState.success,
          profile: response.profileModel,
          contributionScore: response.scoreModel,
          isOrganization: organization.isNotEmpty,
          citizenshipUpgradeStatus: citizenshipUpgradeStatus,
        );
      }
    }
  }
}
