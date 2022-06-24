import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
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
      final ProfileModel? profileModel = response.profileModel;
      if (profileModel != null && profileModel.account == settingsStorage.accountName) {
        // Storing the status in settings is problematic since it's a server side value.
        // As a remedy, we are now updating it every time we load the user profile.
        settingsStorage.saveCitizenshipStatus(profileModel.status);
      }

      final bool isCitizen = profileModel?.status == ProfileStatus.citizen;

      if (isCitizen) {
        return currentState.copyWith(
            pageState: PageState.success, profile: response.profileModel, contributionScore: response.scoreModel);
      } else {
        final organization = response.organizationModel ?? [];

        final CitizenshipUpgradeStatus citizenshipUpgradeStatus;
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
