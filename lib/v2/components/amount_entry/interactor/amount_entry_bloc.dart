import 'package:bloc/bloc.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_events.dart';
import 'package:seeds/v2/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/v2/screens/explore_screens/invite/interactor/viewmodels/invite_event.dart';

class AmountEntryBloc extends Bloc<AmountEntryEvent, AmountEntryState> {
  AmountEntryBloc() : super(AmountEntryState.initial());

  @override
  Stream<AmountEntryState> mapEventToState(AmountEntryEvent event) async* {
    if (event is TabCurrencySwitchButton) {
      int precision = event.intPrecision;

      if (precision == 4) {
        precision = 2;
      } else {
        precision = 4;
      }
      yield state.copyWith(decimalPrecision: changeDecimalPrecision(precision));
    } else if (event is OnAmountChange) {
      // yield SendAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged);
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
