import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';

class EditRegionEventStateMapper extends StateMapper {
  EditRegionEventState mapResultToState(EditRegionEventState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(
          isSaveChangesButtonLoading: false, pageCommand: ShowErrorMessage("Error Editing Region Event"));
    } else {
      return currentState.copyWith(pageCommand: NavigateToRoute(Routes.region));
    }
  }
}
