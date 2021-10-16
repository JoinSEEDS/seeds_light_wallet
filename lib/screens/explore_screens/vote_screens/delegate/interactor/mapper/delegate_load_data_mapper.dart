import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateLoadDataStateMapper extends StateMapper {
  DelegateState mapResultToState(DelegateState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final DelegateModel delegate = result.asValue!.value as DelegateModel;

      if (delegate.delegatee.isEmpty) {
        if (settingsStorage.isFirstTimeOnDelegateScreen) {
          return currentState.copyWith(pageState: PageState.success, activeDelegate: false, delegate: delegate);
        } else {
          settingsStorage.saveFirstTimeOnDelegateScreen(true);
          return currentState.copyWith(
              pageState: PageState.success,
              activeDelegate: false,
              delegate: delegate,
              pageCommand: ShowOnboardingDelegate());
        }
      } else {
        return currentState.copyWith(pageState: PageState.success, activeDelegate: true, delegate: delegate);
      }
    }
  }
}
