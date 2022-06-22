import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class UpgradeCitizenshipResultMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result, ProfileStatus newStatus) {
    if (result.isError) {
      /// citizenship upgrade error, show snackbar fail
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to upgrade citizenship status.'.i18n),
      );
    } else {
      /// Show citizenship upgrade success
      settingsStorage.saveCitizenshipStatus(newStatus);
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowCitizenshipUpgradeSuccess(newStatus),
        profile: currentState.profile!.copyWith(status: newStatus),
      );
    }
  }
}
