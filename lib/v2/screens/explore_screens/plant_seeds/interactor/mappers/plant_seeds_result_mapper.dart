import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';

class PlantSeedsResultMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      var response = result.asValue!.value as TransactionResponse;

      if (response.transactionId.isNotEmpty) {
        return currentState.copyWith(pageState: PageState.success, showPlantedSuccess: true);
      } else {
        return currentState.copyWith(
          pageState: PageState.failure,
          errorMessage: 'Error transaction hash not retrieved',
        );
      }
    }
  }
}
