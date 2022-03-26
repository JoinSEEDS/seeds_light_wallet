import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_page_command.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_errors.dart';

class PlantSeedsResultMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowError(PlantSeedsError.plantFailed),
        isPlantSeedsButtonEnabled: false,
      );
    } else {
      eventBus.fire(const OnNewTransactionEventBus(null));
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowPlantSeedsSuccess());
    }
  }
}
