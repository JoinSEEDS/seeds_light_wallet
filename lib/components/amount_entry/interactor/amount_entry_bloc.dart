import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/currency_change_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_events.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class AmountEntryBloc extends Bloc<AmountEntryEvent, AmountEntryState> {
  AmountEntryBloc(RatesState rates, TokenModel token) : super(AmountEntryState.initial(rates, token));

  @override
  Stream<AmountEntryState> mapEventToState(AmountEntryEvent event) async* {
    if (event is OnCurrencySwitchButtonTapped) {
      yield CurrencyChangeMapper().mapResultToState(state);
    } else if (event is OnAmountChange) {
      yield AmountChangeMapper().mapResultToState(state, event.amountChanged);
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
