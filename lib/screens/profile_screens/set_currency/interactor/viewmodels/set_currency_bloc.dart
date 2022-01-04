import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/currency.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/set_currency/interactor/mappers/rates_state_mapper.dart';

part 'set_currency_event.dart';
part 'set_currency_state.dart';

class SetCurrencyBloc extends Bloc<SetCurrencyEvent, SetCurrencyState> {
  SetCurrencyBloc() : super(SetCurrencyState.initial()) {
    on<LoadCurrencies>((event, emit) => emit(RateStateMapper().mapResultToState(state, event.rates)));
    on<OnQueryChanged>(_onQueryChanged);
  }

  void _onQueryChanged(OnQueryChanged event, Emitter<SetCurrencyState> emit) {
    if (event.query.isNotEmpty) {
      // Get only currencies match the user query
      final queryResult = state.availableCurrencies!
          .where((i) =>
              i.code.toLowerCase().contains(event.query.toLowerCase()) ||
              i.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(currentQuery: event.query, queryCurrenciesResults: queryResult));
    } else {
      // Empty query -> clean results
      emit(state.copyWith(queryCurrenciesResults: state.availableCurrencies));
    }
  }
}
