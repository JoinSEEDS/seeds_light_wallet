import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class UserBalanceAndPlantedStateMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, List<Result> results, RatesState rateState) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      print('UserBalanceAndPlantedStateMapper mapResultsToState length = ${results.length}');
      results.retainWhere((i) => i.isValue);
      var values = results.map((i) => i.asValue!.value).toList();

      BalanceModel? balance = values.firstWhere((element) => element is BalanceModel, orElse: () => null);
      PlantedModel? plantedSeeds = values.firstWhere((element) => element is PlantedModel, orElse: () => null);
      String? selectedFiat = settingsStorage.selectedFiatCurrency;

      return currentState.copyWith(
        pageState: PageState.success,
        fiatAmount: rateState.fromSeedsToFiat(0, selectedFiat).fiatFormatted,
        availableBalance: balance,
        availableBalanceFiat: rateState.fromSeedsToFiat(balance?.quantity ?? 0, selectedFiat).fiatFormatted,
        plantedBalance: plantedSeeds?.formattedQuantity,
        plantedBalanceFiat: rateState.fromSeedsToFiat(plantedSeeds?.quantity ?? 0, selectedFiat).fiatFormatted,
      );
    }
  }
}
