import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/mappers/rates_state_mapper.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/rates/usecases/get_rates_use_case.dart';

/// --- BLOC
class RatesBloc extends Bloc<RatesEvent, RatesState> {
  DateTime lastUpdated = DateTime.now().subtract(const Duration(hours: 1));

  RatesBloc() : super(RatesState.initial());

  @override
  Stream<RatesState> mapEventToState(RatesEvent event) async* {
    if (event is FetchRates) {
      if (DateTime.now().isAfter(lastUpdated.add(const Duration(hours: 1)))) {
        var results = await GetRatesUseCase().run();
        yield RatesStateMapper().mapResultToState(state, results);
      }
    }
  }
}
