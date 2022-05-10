import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class SaveImageStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(isNextButtonLoading: false, pageCommand: ShowErrorMessage("Error saving image"));
    } else {
      return currentState.copyWith(
          isNextButtonLoading: false,
          createImageUrl: false,
          imageUrl: result.asValue!.value,
          createRegionEventScreen: CreateRegionEventScreen.reviewAndPublish);
    }
  }
}
