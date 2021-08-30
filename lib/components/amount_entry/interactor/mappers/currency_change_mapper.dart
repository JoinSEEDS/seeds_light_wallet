import 'package:seeds/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/page_command.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class CurrencyChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState) {
    final input = currentState.currentCurrencyInput == CurrencyInput.token ? CurrencyInput.fiat : CurrencyInput.token;

    return currentState.copyWith(
      currentCurrencyInput: input,
      enteringCurrencyName: handleEnteringCurrencyName(input),
      pageCommand: SendTextInputDataBack(
        handleAmountToSendBack(
          currentCurrencyInput: input,
          textInput: currentState.textInput,
          fiatToSeeds: currentState.tokenAmount.amountString(),
        ),
      ),
    );
  }
}

String handleEnteringCurrencyName(CurrencyInput currentCurrencyInput) {
  switch (currentCurrencyInput) {
    case CurrencyInput.fiat:
      return settingsStorage.selectedFiatCurrency;
    case CurrencyInput.token:
      return settingsStorage.selectedToken.symbol;
  }
}
