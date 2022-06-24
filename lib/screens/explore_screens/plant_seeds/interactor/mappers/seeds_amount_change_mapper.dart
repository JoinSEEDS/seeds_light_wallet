import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class SeedsAmountChangeMapper extends StateMapper {
  PlantSeedsState mapResultToState(PlantSeedsState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final tokenAmount = TokenDataModel(parsedQuantity);
    final double currentAvailable = currentState.availableBalance?.amount ?? 0;
    final String selectedFiat = settingsStorage.selectedFiatCurrency;

    return currentState.copyWith(
      tokenAmount: tokenAmount,
      fiatAmount: rateState.tokenToFiat(tokenAmount, selectedFiat),
      isPlantSeedsButtonEnabled: parsedQuantity > 0 && parsedQuantity <= currentAvailable,
      showAlert: parsedQuantity > currentAvailable,
    );
  }
}
