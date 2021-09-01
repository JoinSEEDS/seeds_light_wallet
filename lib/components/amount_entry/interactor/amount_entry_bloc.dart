import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/mappers/currency_change_mapper.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_events.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';

class AmountEntryBloc extends Bloc<AmountEntryEvent, AmountEntryState> {
  AmountEntryBloc(RatesState rates, TokenDataModel tokenDataModel)
      : super(AmountEntryState.initial(rates, tokenDataModel: tokenDataModel));

  @override
  Stream<AmountEntryState> mapEventToState(AmountEntryEvent event) async* {
    if (event is OnCurrencySwitchButtonTapped) {
      yield CurrencyChangeMapper().mapResultToState(state);
      add(OnAmountChange(amountChanged: state.textInput));
    } else if (event is OnAmountChange) {
      yield AmountChangeMapper().mapResultToState(state, event.amountChanged);
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
