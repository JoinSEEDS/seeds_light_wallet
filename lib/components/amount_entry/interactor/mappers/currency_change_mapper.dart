import 'package:seeds/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class CurrencyChangeMapper extends StateMapper {
  AmountEntryState mapResultToState(AmountEntryState currentState) {
    final input = currentState.currentCurrencyInput == CurrencyInput.token ? CurrencyInput.fiat : CurrencyInput.token;

    return currentState.copyWith(
      currentCurrencyInput: input,
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
