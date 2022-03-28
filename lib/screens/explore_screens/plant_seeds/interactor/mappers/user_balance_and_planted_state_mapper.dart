import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_errors.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class UserBalanceAndPlantedStateMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, List<Result> results, RatesState rateState) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, error: PlantSeedsError.errorLoadingPage);
    } else {
      results.retainWhere((i) => i.isValue);
      final values = results.map((i) => i.asValue!.value).toList();

      final BalanceModel? balance = values.whereType<BalanceModel>().firstOrNull;
      final PlantedModel? plantedSeeds = values.whereType<PlantedModel>().firstOrNull;
      final String selectedFiat = settingsStorage.selectedFiatCurrency;

      final availableBalance = TokenDataModel.from(balance?.quantity);
      final tokenAmount = TokenDataModel(0);
      final plantedAmount = TokenDataModel(plantedSeeds?.quantity ?? 0);

      return currentState.copyWith(
        pageState: PageState.success,
        fiatAmount: rateState.tokenToFiat(tokenAmount, selectedFiat),
        availableBalance: availableBalance,
        availableBalanceFiat: availableBalance != null ? rateState.tokenToFiat(availableBalance, selectedFiat) : null,
        plantedBalance: TokenDataModel.from(plantedSeeds?.quantity),
        plantedBalanceFiat: rateState.tokenToFiat(plantedAmount, selectedFiat),
      );
    }
  }
}
