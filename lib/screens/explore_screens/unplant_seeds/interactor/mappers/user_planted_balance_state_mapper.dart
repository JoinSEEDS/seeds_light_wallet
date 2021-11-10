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
      results.retainWhere((Result i) => i.isValue);
      final values = results.map((Result i) => i.asValue!.value).toList();
      final String selectedFiat = settingsStorage.selectedFiatCurrency;

      final PlantedModel? plantedSeeds = values.firstWhere((i) => i is PlantedModel, orElse: () => null);
      final plantedAmount = TokenDataModel(plantedSeeds?.quantity ?? 0);

      final List<int> availableRequestIds = [];
      bool enableClaimButton = false;
      double availableTotalClaim = 0;
      final List<RefundModel> refunds = values.firstWhere((i) => i is List<RefundModel>, orElse: () => []);

      for (final element in refunds) {
        final elementRefund = element.claimAmount(DateTime.now());
        if (elementRefund > 0) {
          availableTotalClaim += elementRefund;
          enableClaimButton = true;
          availableRequestIds.add(element.requestId);
        }
      }

      return currentState.copyWith(
        showMinPlantedBalanceAlert: (plantedSeeds?.quantity ?? 0) <= minPlanted,
        pageState: PageState.success,
        plantedBalance: TokenDataModel.from(plantedSeeds?.quantity ?? 0),
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
