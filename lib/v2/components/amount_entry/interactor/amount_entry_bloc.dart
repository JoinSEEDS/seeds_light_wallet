import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_events.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/mappers/AmountChangerMapper.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/pageCommand.dart';

class AmountEntryBloc extends Bloc<AmountEntryEvent, AmountEntryState> {
  AmountEntryBloc(RatesState rates) : super(AmountEntryState.initial(rates));

  @override
  Stream<AmountEntryState> mapEventToState(AmountEntryEvent event) async* {
    if (event is TabCurrencySwitchButton) {
      yield state.copyWith(
          decimalPrecision: changeDecimalPrecision(state.decimalPrecision),
          currentCurrencyInput: ChangeCurrencyInput(state.currentCurrencyInput),
          pageCommand: SendTextInputDataBack());
    } else if (event is OnAmountChange) {
      yield AmountChangeMapper().mapResultToState(
        state,
        state.ratesState,
        event.amountChanged,
      );
      yield state.copyWith(pageCommand: SendTextInputDataBack(), textInput: event.amountChanged);
    } else if (event is ClearPageCommand) {
      yield state.copyWith(pageCommand: null);
    }
  }
}

int changeDecimalPrecision(int decimalPrecision) {
  if (decimalPrecision == 4) {
    return 2;
  } else {
    return 4;
  }
}

CurrencyInput ChangeCurrencyInput(CurrencyInput currentCurrencyInput) {
  if (currentCurrencyInput == CurrencyInput.SEEDS) {
    return CurrencyInput.FIAT;
  } else {
    return CurrencyInput.SEEDS;
  }
}
