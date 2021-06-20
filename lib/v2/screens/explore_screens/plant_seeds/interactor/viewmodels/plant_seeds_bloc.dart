import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/mappers/plant_seeds_result_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/mappers/seeds_amount_change_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/mappers/user_balance_and_planted_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/usecases/get_available_balance_and_planted_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/usecases/plant_seeds_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/bloc.dart';

/// --- BLOC
class PlantSeedsBloc extends Bloc<PlantSeedsEvent, PlantSeedsState> {
  PlantSeedsBloc(RatesState rates) : super(PlantSeedsState.initial(rates));

  @override
  Stream<PlantSeedsState> mapEventToState(PlantSeedsEvent event) async* {
    if (event is LoadUserBalance) {
      yield state.copyWith(pageState: PageState.loading);
      List<Result> results = await GetAvailableBalanceAndPlantedDataUseCase().run();
      yield UserBalanceAndPlantedStateMapper().mapResultToState(state, results, state.ratesState);
    }
    if (event is OnAmountChange) {
      yield SeedsAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged);
    }
    if (event is OnPlantSeedsButtonTapped) {
      yield state.copyWith(pageState: PageState.loading, isAutoFocus: false);
      Result result = await PlantSeedsUseCase().run(amount: state.quantity);
      yield PlantSeedsResultMapper().mapResultToState(state, result);
    }
  }
}
