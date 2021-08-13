import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/v2/domain-shared/event_bus/events.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';
import 'package:seeds/v2/i18n/explore_screens/plant_seeds/plant_seeds.i18n.dart';

class PlantSeedsResultMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, Result result) {
    if (result.isError) {
      // Transaction fail show snackbar fail
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Plant failed, try again.'.i18n),
        isPlantSeedsButtonEnabled: false,
      );
    } else {
      // Transaction success show plant seeds success dialog
      eventBus.fire(const OnNewTransactionEventBus());

      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowPlantSeedsSuccess());
    }
  }
}
