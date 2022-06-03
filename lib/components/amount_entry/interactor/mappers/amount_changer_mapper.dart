import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_bloc.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/page_commands.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class AmountChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final selectedFiat = settingsStorage.selectedFiatCurrency;

    TokenDataModel? tokenAmount;
    FiatDataModel? fiatAmount;

    if (currentState.currentCurrencyInput == CurrencyInput.fiat) {
      fiatAmount = FiatDataModel(parsedQuantity, fiatSymbol: settingsStorage.selectedFiatCurrency);
      tokenAmount = currentState.ratesState.fiatToToken(fiatAmount, currentState.tokenAmount.id!);
    } else {
      tokenAmount = currentState.tokenAmount.copyWith(parsedQuantity);
      fiatAmount = currentState.ratesState.tokenToFiat(tokenAmount, selectedFiat);
    }

    return currentState.copyWith(
        tokenAmount: tokenAmount,
        fiatAmount: fiatAmount,
        textInput: quantity,
        pageCommand: SendTextInputDataBack(handleAmountToSendBack(
          currentCurrencyInput: currentState.currentCurrencyInput,
          textInput: quantity,
          fiatToSeeds: tokenAmount?.amountString() ?? "",
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
