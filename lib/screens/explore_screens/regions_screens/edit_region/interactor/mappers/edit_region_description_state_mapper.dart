import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';

class EditRegionDescriptionStateMapper extends StateMapper {
  EditRegionState mapResultToState(EditRegionState currentState, Result<TransactionResponse> result) {
    if (result.isError) {
      return currentState.copyWith(
          isSaveChangesButtonLoading: false, pageCommand: ShowErrorMessage("Error Editing Region Description"));
    } else {
      return currentState.copyWith(
        pageCommand: NavigateToRoute(Routes.region),
      );
    }
  }
}
