import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/i18n/profile_screens/profile/profile.i18n.dart';

class UpgradeCitizenshipResultMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result, bool isResident) {
    if (result.isError) {
      /// citizenship upgrade error, show snackbar fail
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to upgrade citizenship status.'.i18n),
      );
    } else {
      /// Show citizenship upgrade success

      ProfileStatus nextProfileStatus;

      isResident ? nextProfileStatus = ProfileStatus.citizen : nextProfileStatus = ProfileStatus.resident;

      return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowCitizenshipUpgradeSuccess(isResident),
          profile: currentState.profile!.copyWith(status: nextProfileStatus));
    }
  }
}
