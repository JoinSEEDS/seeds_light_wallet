import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/region_event_details_bloc.dart';

class DeleteRegionEventStateMapper extends StateMapper {
  RegionEventDetailsState mapResultToState(RegionEventDetailsState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: ShowErrorMessage("Error Deleting Region Event"));
    } else {
      return currentState.copyWith(pageCommand: NavigateToRoute(Routes.region));
    }
  }
}
