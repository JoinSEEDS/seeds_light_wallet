import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class SaveImageStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowErrorMessage("Error saving image"));
    } else {
      return currentState.copyWith(
          pageState: PageState.success,
          imageUrl: result.asValue!.value,
          createRegionsScreens: CreateRegionScreen.reviewRegion);
    }
  }
}
