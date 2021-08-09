import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class UpgradeCitizenshipResultMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result, List<Result> results, bool isResident) {
    if (result.isError) {
      /// citizenship upgrade error, show snackbar fail
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to upgrade citizenship status.'),
      );
    } else {
      /// Show citizenship upgrade success
      ProfileModel? profile = results[0].valueOrNull;

      return currentState.copyWith(
          pageState: PageState.success, pageCommand: ShowCitizenshipUpgradeSuccess(isResident), profile: profile);
    }
  }
}

extension _ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
