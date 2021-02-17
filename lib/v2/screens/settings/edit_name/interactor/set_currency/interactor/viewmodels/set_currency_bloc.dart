import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/set_currency/interactor/mappers/rates_state_mapper.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/set_currency/interactor/usecases/get_fiat_rates_use_case.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/set_currency/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SetCurrencyBloc extends Bloc<SetCurrencyEvent, SetCurrencyState> {
  SetCurrencyBloc() : super(SetCurrencyState.initial());

  @override
  Stream<SetCurrencyState> mapEventToState(SetCurrencyEvent event) async* {
    if (event is LoadCurrencies) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await GetFiatRatesUseCase().run();
      yield RatesStateMapper().mapToState(state, result);
    }
  }
}
