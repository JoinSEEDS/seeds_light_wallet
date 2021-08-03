import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

class UpgradeCitizenshipResultMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result, bool isResident) {
    String newCitizenshipStatus;

    if (result.isError) {
      // citizenship upgrade error, show snackbar fail
      print('Error upgrading citizenship status');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to upgrade citizenship status.'),
      );
    } else {
      // Show citizenship upgrade success
      if (isResident) {
        newCitizenshipStatus = "Citizen";
      } else {
        newCitizenshipStatus = "Resident";
      }

      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowCitizenshipUpgradeSuccess(newCitizenshipStatus),
      );
    }
  }
}
