import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/explore_screens/plant_seeds/plant_seeds.i18n.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';

class PlantSeedsResultMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Plant failed, try again.'.i18n),
        isPlantSeedsButtonEnabled: false,
      );
    } else {
      eventBus.fire(const OnNewTransactionEventBus(null));
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowPlantSeedsSuccess());
    }
  }
}
