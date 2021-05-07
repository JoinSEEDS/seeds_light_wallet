import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class SeedsAmountChangeMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, RatesState rateState, String quantity) {
    double parsedQuantity = double.tryParse(quantity) ?? 0;
    String selectedFiat = settingsStorage.selectedFiatCurrency ?? 'USD';

    return currentState.copyWith(
      fiatAmount: rateState.currencyString(parsedQuantity, selectedFiat),
      isPlantSeedsButtonEnabled: parsedQuantity > 0,
      // quantity: parsedQuantity,
    );
  }
}
