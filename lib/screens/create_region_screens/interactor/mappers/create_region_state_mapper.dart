import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class CreateRegionStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState, Result<TransactionResponse> result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: ShowErrorMessage("Error Creating Region"));
    } else {
      print(' Transaction ID: ${result.asValue!.value.transactionId}');
      return currentState.copyWith(
        pageState: PageState.success,
        createRegionsScreens: CreateRegionScreen.reviewRegion,
        pageCommand: NavigateToRoute(Routes.region),
      );
    }
  }
}
