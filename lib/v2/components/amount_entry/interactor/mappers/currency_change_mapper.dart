import 'package:seeds/v2/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/v2/components/amount_entry/interactor/mappers/handle_info_row_text.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/page_command.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class CurrencyChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState) {
    var input = currentState.currentCurrencyInput == CurrencyInput.SEEDS ? CurrencyInput.FIAT : CurrencyInput.SEEDS;

    return currentState.copyWith(
        currentCurrencyInput: input,
        infoRowText: handleInfoRowText(
          currentCurrencyInput: input,
          fiatToSeeds: currentState.fiatToSeeds,
          seedsToFiat: currentState.seedsToFiat,
        ),
        enteringCurrencyName: handleEnteringCurrencyName(input),
        pageCommand: SendTextInputDataBack(handleAmountToSendBack(
          currentCurrencyInput: input,
          textInput: currentState.textInput,
          fiatToSeeds: currentState.fiatToSeeds,
        )));
  }
}

String handleEnteringCurrencyName(CurrencyInput currentCurrencyInput) {
  switch (currentCurrencyInput) {
    case CurrencyInput.FIAT:
      return settingsStorage.selectedFiatCurrency.toString();
    case CurrencyInput.SEEDS:
      return currencySeedsCode;
  }
}
