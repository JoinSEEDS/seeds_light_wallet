import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/mappers/rates_state_mapper.dart';
import 'package:seeds/blocs/rates/usecases/get_rates_use_case.dart';
import 'package:seeds/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'rates_event.dart';
part 'rates_state.dart';

class RatesBloc extends Bloc<RatesEvent, RatesState> {
  DateTime lastUpdated = DateTime.now();

  RatesBloc() : super(RatesState.initial()) {
    on<OnFetchRates>(_onFetchRates);
  }

  Future<void> _onFetchRates(OnFetchRates event, Emitter<RatesState> emit) async {
    print('Remaining minutes to fetch rates again: ${lastUpdated.difference(DateTime.now()).inMinutes}');
    if (DateTime.now().isAfter(lastUpdated)) {
      lastUpdated = lastUpdated.add(const Duration(hours: 1));
      final results = await GetRatesUseCase().run();
      emit(RatesStateMapper().mapResultToState(state, results));
    }
  }
}
