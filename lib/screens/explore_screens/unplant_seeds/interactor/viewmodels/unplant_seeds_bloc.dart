import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/claim_seeds_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/unplant_seeds_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/user_planted_balance_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/usecases/claim_seeds_use_case.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/usecases/get_planted_balance_use_case.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/usecases/unplant_seeds_use_case.dart';

part 'unplant_seeds_event.dart';
part 'unplant_seeds_state.dart';

class UnplantSeedsBloc extends Bloc<UnplantSeedsEvent, UnplantSeedsState> {
  UnplantSeedsBloc(RatesState rates)
      : super(UnplantSeedsState.initial(rates, remoteConfigurations.featureFlagClaimUnplantedSeedsEnabled)) {
    on<LoadUserPlantedBalance>(_loadUserPlantedBalance);
    on<OnAmountChange>(_onAmountChange);
    on<OnMaxButtonTapped>(_onMaxButtonTapped);
    on<OnUnplantSeedsButtonTapped>(_onUnplantSeedsButtonTapped);
    on<OnClaimButtonTapped>(_onClaimButtonTapped);
  }

  Future<void> _loadUserPlantedBalance(LoadUserPlantedBalance event, Emitter<UnplantSeedsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final results = await GetPlantedBalanceUseCase().run();
    emit(UserPlantedBalanceStateMapper().mapResultToState(state, results));
  }

  void _onAmountChange(OnAmountChange event, Emitter<UnplantSeedsState> emit) {
    emit(AmountChangerMapper().mapResultToState(state, event.amountChanged));
  }

  void _onMaxButtonTapped(OnMaxButtonTapped event, Emitter<UnplantSeedsState> emit) {
    final double plantedBalance = state.plantedBalance?.amount ?? 0;
    final double maxAmount = plantedBalance - minPlanted;
    emit(AmountChangerMapper().mapResultToState(state, maxAmount.toString()));
  }

  Future<void> _onUnplantSeedsButtonTapped(OnUnplantSeedsButtonTapped event, Emitter<UnplantSeedsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, onFocus: false));
    final Result result = await UnplantSeedsUseCase().run(amount: state.unplantedInputAmount.amount);
    emit(UnplantSeedsResultMapper().mapResultToState(state, result));
  }

  Future<void> _onClaimButtonTapped(OnClaimButtonTapped event, Emitter<UnplantSeedsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await ClaimSeedsUseCase().run(requestIds: state.availableRequestIds!);
    emit(ClaimSeedsResultMapper().mapResultToState(state, result));
  }
}
