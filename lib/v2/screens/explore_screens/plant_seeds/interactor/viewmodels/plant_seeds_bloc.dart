import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/mappers/seeds_amount_change_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/mappers/user_balance_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/usecases/get_available_balance_use_case.dart';

/// --- BLOC
class PlantSeedsBloc extends Bloc<PlantSeedsEvent, PlantSeedsState> {
  PlantSeedsBloc(RatesState rates) : super(PlantSeedsState.initial(rates));

  @override
  Stream<PlantSeedsState> mapEventToState(PlantSeedsEvent event) async* {
    if (event is LoadUserBalance) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await GetAvailableBalanceUseCase().run(settingsStorage.accountName);
      yield UserBalanceStateMapper().mapResultToState(state, result, state.ratesState);
    }
    if (event is OnAmountChange) {
      yield SeedsAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged);
    }
  }
}
