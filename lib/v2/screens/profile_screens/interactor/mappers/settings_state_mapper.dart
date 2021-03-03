import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/settings/interactor/viewmodels/settings_state.dart';

class SettingsStateMapper extends StateMapper {
  SettingsState mapResultToState(SettingsState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue.value);
    }
  }
}
