import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class AmountChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState, RatesState rateState, String quantity) {
    double parsedQuantity = double.tryParse(quantity) ?? 0;
    var selectedFiat = settingsStorage.selectedFiatCurrency;

    String fiatAmount = rateState.fromSeedsToFiat(parsedQuantity, selectedFiat);
    String fiatToSeeds = rateState.fromFiatToSeeds(parsedQuantity, selectedFiat);

    return currentState.copyWith(seedsAmount: quantity, fiatToSeeds: fiatToSeeds, seedsToFiat: fiatAmount);
  }
}
