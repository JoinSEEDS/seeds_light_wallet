import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_page_commads.dart';

class SaveRegionImageUrlStateMapper extends StateMapper {
  EditRegionState mapResultToState(EditRegionState currentState, Result<String> result) {
    if (result.isError) {
      return currentState.copyWith(
          isSaveChangesButtonLoading: false, pageCommand: ShowErrorMessage("Error Saving Image"));
    } else {
      return currentState.copyWith(pageCommand: UpdateFirebaseRegionImage(), imageUrl: result.asValue!.value);
    }
  }
}
