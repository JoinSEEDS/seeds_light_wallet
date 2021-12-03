import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_page_commands.dart';

class ClaimSeedsResultMapper extends StateMapper {
  UnplantSeedsState mapResultToState(UnplantSeedsState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Claim failed, try again.'),
      );
    } else {
      eventBus.fire(const OnNewTransactionEventBus(null));
      return currentState.copyWith(
        onFocus: false,
        pageState: PageState.success,
        pageCommand:
            ShowClaimSeedsSuccess(currentState.availableClaimBalance!, currentState.availableClaimBalanceFiat!),
      );
    }
  }
}
