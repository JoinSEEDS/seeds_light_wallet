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
    if (event is LoadCurrencies) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await GetFiatRatesUseCase().run();
      yield RateStateMapper().mapResultToState(state, result);
    }
    if (event is OnQueryChanged) {
      if (event.query.isNotEmpty) {
        // Get only currencies match the user query
        final queryResult = state.availableCurrencies.where((i) => i.code.contains(event.query)).toList();
        yield state.copyWith(currentQuery: event.query, queryCurrenciesResults: queryResult);
      } else {
        // Empty query clean results
        yield state.copyWith(queryCurrenciesResults: state.availableCurrencies);
      }
    }
  }
}
