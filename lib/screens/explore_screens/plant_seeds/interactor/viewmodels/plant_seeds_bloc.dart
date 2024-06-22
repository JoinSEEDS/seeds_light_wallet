import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/mappers/plant_seeds_result_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/mappers/seeds_amount_change_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/mappers/user_balance_and_planted_state_mapper.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/usecases/get_available_balance_and_planted_use_case.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/usecases/plant_seeds_use_case.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_errors.dart';

part 'plant_seeds_event.dart';
part 'plant_seeds_state.dart';

class PlantSeedsBloc extends Bloc<PlantSeedsEvent, PlantSeedsState> {
  PlantSeedsBloc(RatesState rates) : super(PlantSeedsState.initial(rates)) {
    on<LoadUserBalance>(_loadUserBalance);
    on<OnAmountChange>(_onAmountChange);
    on<OnPlantSeedsButtonTapped>(_onPlantSeedsButtonTapped);
  }
  Future<void> _loadUserBalance(LoadUserBalance event, Emitter<PlantSeedsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final List<Result> results = await GetAvailableBalanceAndPlantedDataUseCase().run();
    emit(UserBalanceAndPlantedStateMapper().mapResultToState(state, results, state.ratesState));
  }

  void _onAmountChange(OnAmountChange event, Emitter<PlantSeedsState> emit) {
    emit(SeedsAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged));
  }

  Future<void> _onPlantSeedsButtonTapped(OnPlantSeedsButtonTapped event, Emitter<PlantSeedsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, isAutoFocus: false));
    final Result result = await PlantSeedsUseCase().run(amount: state.tokenAmount.amount);
    emit(PlantSeedsResultMapper().mapResultToState(state, result));
  }
}
