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
      final List<RefundModel> refunds;
      final List<int> availableRequestIds = [];
      final int millisecondsPerWeek = 24 * 60 * 60 * 1000;
      refunds = results[1].asValue?.value as List<RefundModel>;
      bool enableClaimButton = false;
      double availableTotalClaim = 0;

      for (final element in refunds) {
        final int claimDate = (element.requestTime * 1000) + (element.weeksDelay * millisecondsPerWeek);

        if (DateTime.now().millisecondsSinceEpoch > claimDate) {
          availableTotalClaim = availableTotalClaim + double.parse(element.amount.replaceAll('SEEDS', ''));
          if (availableRequestIds.isEmpty) {
            enableClaimButton = true;
            availableRequestIds.add(element.requestId);
          } else if (availableRequestIds.last != element.requestId) {
            availableRequestIds.add(element.requestId);
          }
        }
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
        isClaimButtonEnabled: enableClaimButton,
      );
    }
  }
}
