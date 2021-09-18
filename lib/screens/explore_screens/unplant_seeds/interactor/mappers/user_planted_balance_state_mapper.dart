import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class UserPlantedBalanceStateMapper extends StateMapper {
  UnplantSeedsState mapResultToState(UnplantSeedsState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
      );
    } else {
      final PlantedModel plantedSeeds = result.asValue!.value as PlantedModel;
      final String selectedFiat = settingsStorage.selectedFiatCurrency;
      final plantedAmount = TokenDataModel(plantedSeeds.quantity);

      return currentState.copyWith(
        pageState: PageState.success,
        plantedBalance: TokenDataModel.from(plantedSeeds.quantity),
        plantedBalanceFiat: currentState.ratesState.tokenToFiat(plantedAmount, selectedFiat),
      );
    }
  }
}
