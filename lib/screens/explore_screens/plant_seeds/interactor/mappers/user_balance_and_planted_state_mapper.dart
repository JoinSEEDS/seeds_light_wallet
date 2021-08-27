import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';
import 'package:seeds/i18n/explore_screens/plant_seeds/plant_seeds.i18n.dart';

class UserBalanceAndPlantedStateMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, List<Result> results, RatesState rateState) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      results.retainWhere((i) => i.isValue);
      final values = results.map((i) => i.asValue!.value).toList();

      final BalanceModel? balance = values.firstWhere((element) => element is BalanceModel, orElse: () => null);
      final PlantedModel? plantedSeeds = values.firstWhere((element) => element is PlantedModel, orElse: () => null);
      final String selectedFiat = settingsStorage.selectedFiatCurrency;

      final availableBalance = TokenDataModel.fromSeedsOrNull(balance?.quantity);
      final tokenAmount = TokenDataModel.fromSeeds(0);
      final plantedAmount = TokenDataModel.fromSeeds(plantedSeeds?.quantity ?? 0);

      return currentState.copyWith(
        pageState: PageState.success,
        fiatAmount: rateState.tokenToFiat(tokenAmount, selectedFiat),
        availableBalance: availableBalance,
        availableBalanceFiat: availableBalance != null ? rateState.tokenToFiat(availableBalance, selectedFiat) : null,
        plantedBalance: TokenDataModel.fromSeedsOrNull(plantedSeeds?.quantity),
        plantedBalanceFiat: rateState.tokenToFiat(plantedAmount, selectedFiat),
      );
    }
  }
}
