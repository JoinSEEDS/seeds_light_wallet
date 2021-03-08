import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/mappers/rates_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/usecases/get_fiat_rates_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SetCurrencyBloc extends Bloc<SetCurrencyEvent, SetCurrencyState> {
  SetCurrencyBloc() : super(SetCurrencyState.initial());

  @override
  Stream<SetCurrencyState> mapEventToState(SetCurrencyEvent event) async* {
    if (event is OnQueryChanged) {
      if (event.query.isNotEmpty && event.query.length == 3 && event.query != state.currentQuery) {
        yield state.copyWith(pageState: PageState.loading, currentQuery: event.query);
        Result result = await GetFiatRatesUseCase().run(query: event.query);
        yield RateStateMapper().mapResultToState(state, result);
      } else {
        yield state.copyWith(availableCurrencies: event.query != state.currentQuery ? [] : null);
      }
    }
  }
}
