import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class SeedsAmountChangeMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, RatesState rateState, String quantity) {
    double parsedQuantity = double.tryParse(quantity) ?? 0;
    double currentAvailable = currentState.availableBalance?.quantity ?? 0;
    String? selectedFiat = settingsStorage.selectedFiatCurrency;

    return currentState.copyWith(
      fiatAmount: rateState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted,
      isPlantSeedsButtonEnabled: parsedQuantity > 0 && parsedQuantity < currentAvailable,
      quantity: parsedQuantity,
      showAlert: parsedQuantity > currentAvailable,
    );
  }
}
