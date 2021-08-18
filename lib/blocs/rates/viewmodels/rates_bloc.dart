import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/mappers/rates_state_mapper.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/blocs/rates/usecases/get_rates_use_case.dart';

/// --- BLOC
class RatesBloc extends Bloc<RatesEvent, RatesState> {
  DateTime lastUpdated = DateTime.now();

  RatesBloc() : super(RatesState.initial());

  @override
  Stream<RatesState> mapEventToState(RatesEvent event) async* {
    if (event is OnFetchRates) {
      print('Remaining minutes to fetch rates again: ${lastUpdated.difference(DateTime.now()).inMinutes}');
      if (DateTime.now().isAfter(lastUpdated)) {
        lastUpdated = lastUpdated.add(const Duration(hours: 1));
        final results = await GetRatesUseCase().run();
        yield RatesStateMapper().mapResultToState(state, results);
      }
    }
  }
}
