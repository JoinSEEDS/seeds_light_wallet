import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class CreateRegionEventStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(
          isPublishEventButtonLoading: false, pageCommand: ShowErrorMessage("Error Creating Region Event"));
    } else {
      return currentState.copyWith(pageCommand: NavigateToRoute(Routes.region));
    }
  }
}
