import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class RemoveDelegateResultMapper extends StateMapper {
  DelegateState mapResultToState(DelegateState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail to remove delegate'),
      );
    } else {
      return currentState.copyWith(
           pageState: PageState.success,
           pageCommand: ShowDelegateRemovalSuccess()
      );
    }
  }
}
