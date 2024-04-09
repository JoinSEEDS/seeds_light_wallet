import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/datasource/remote/model/refund_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_bloc.dart';
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

      final PlantedModel? plantedSeeds = values.firstWhereOrNull((element) => element is PlantedModel) as PlantedModel?;
      final plantedAmount = TokenDataModel(plantedSeeds?.quantity ?? 0);

      final List<int> availableRequestIds = [];
      final int millisecondsPerWeek = 24 * 60 * 60 * 1000 * 7;
      bool enableClaimButton = false;
      double availableTotalClaim = 0;
      final List<RefundModel> refunds = values.firstWhere((i) => i is List<RefundModel>, orElse: () => []) as List<RefundModel>;

      for (final element in refunds) {
        final int claimDate = (element.requestTime * 1000) + (element.weeksDelay * millisecondsPerWeek);

        if (DateTime.now().millisecondsSinceEpoch > claimDate) {
          availableTotalClaim = availableTotalClaim + element.amount;
          if (availableRequestIds.isEmpty) {
            enableClaimButton = true;
            availableRequestIds.add(element.requestId);
          } else if (availableRequestIds.last != element.requestId) {
            availableRequestIds.add(element.requestId);
          }
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
