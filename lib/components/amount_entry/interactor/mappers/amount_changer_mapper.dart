import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/page_command.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class AmountChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final selectedFiat = settingsStorage.selectedFiatCurrency;

    final tokenAmount = TokenDataModel(parsedQuantity, token: settingsStorage.selectedToken);

    final fiatAmount = currentState.ratesState.tokenToFiat(tokenAmount, selectedFiat);

    return currentState.copyWith(
        tokenAmount: tokenAmount,
        fiatAmount: fiatAmount,
        textInput: quantity,
        pageCommand: SendTextInputDataBack(handleAmountToSendBack(
          currentCurrencyInput: currentState.currentCurrencyInput,
          textInput: quantity,
          fiatToSeeds: tokenAmount.amountString(),
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
