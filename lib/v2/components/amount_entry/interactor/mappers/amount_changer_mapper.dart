import 'package:seeds/v2/components/amount_entry/interactor/mappers/handle_info_row_text.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/page_command.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class AmountChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final selectedFiat = settingsStorage.selectedFiatCurrency;

    final String seedsToFiat = currentState.ratesState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted;
    final String fiatToSeeds = currentState.ratesState.fromFiatToSeeds(parsedQuantity, selectedFiat).seedsFormatted;

    return currentState.copyWith(
        seedsAmount: quantity,
        fiatToSeeds: fiatToSeeds,
        seedsToFiat: seedsToFiat,
        textInput: quantity,
        infoRowText: handleInfoRowText(
          currentCurrencyInput: currentState.currentCurrencyInput,
          fiatToSeeds: fiatToSeeds,
          seedsToFiat: seedsToFiat,
        ),
        pageCommand: SendTextInputDataBack(handleAmountToSendBack(
          currentCurrencyInput: currentState.currentCurrencyInput,
          textInput: quantity,
          fiatToSeeds: fiatToSeeds,
        )));
  }
}

String handleAmountToSendBack(
    {required CurrencyInput currentCurrencyInput, required String textInput, required String fiatToSeeds}) {
  switch (currentCurrencyInput) {
    case CurrencyInput.token:
      return textInput;
    case CurrencyInput.fiat:
      return fiatToSeeds.replaceAll(',', '');
  }
}
