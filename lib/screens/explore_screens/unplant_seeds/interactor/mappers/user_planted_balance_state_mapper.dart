import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/datasource/remote/model/refund_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class UserPlantedBalanceStateMapper extends StateMapper {
  UnplantSeedsState mapResultToState(UnplantSeedsState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(
        pageState: PageState.failure,
      );
    } else {
      final PlantedModel plantedSeeds = results[0].asValue!.value as PlantedModel;
      final String selectedFiat = settingsStorage.selectedFiatCurrency;
      final plantedAmount = TokenDataModel(plantedSeeds.quantity);

      double availableTotalClaim = 0;
      final List<RefundModel> refunds;
      final List<int> availableRequestIds = [];

      refunds = results[1].asValue?.value as List<RefundModel>;

      for (final element in refunds) {
        availableTotalClaim = availableTotalClaim + double.parse(element.amount.replaceAll('SEEDS', ''));
        availableRequestIds.add(element.requestId);
      }

      return currentState.copyWith(
        showMinPlantedBalanceAlert: plantedSeeds.quantity <= minPlanted,
        pageState: PageState.success,
        plantedBalance: TokenDataModel.from(plantedSeeds.quantity),
        plantedBalanceFiat: currentState.ratesState.tokenToFiat(plantedAmount, selectedFiat),
        availableClaimBalance: TokenDataModel(availableTotalClaim),
        availableClaimBalanceFiat:
            currentState.ratesState.tokenToFiat(TokenDataModel(availableTotalClaim), selectedFiat),
        availableRequestIds: availableRequestIds,
      );
    }
  }
}
