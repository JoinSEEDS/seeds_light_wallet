import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/amount_changer_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/unplant_seeds_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/mappers/user_planted_balance_state_mapper.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/usecases/get_planted_balance_use_case.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/usecases/unplant_seeds_use_case.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_event.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_state.dart';

class UnplantSeedsBloc extends Bloc<UnplantSeedsEvent, UnplantSeedsState> {
  UnplantSeedsBloc(RatesState rates) : super(UnplantSeedsState.initial(rates));

  @override
  Stream<UnplantSeedsState> mapEventToState(UnplantSeedsEvent event) async* {
    if (event is LoadUserPlantedBalance) {
      yield state.copyWith(pageState: PageState.loading);
      final Result results = await GetPlantedBalanceUseCase().run();
      yield UserPlantedBalanceStateMapper().mapResultToState(
        state,
        results,
      );
    } else if (event is OnAmountChange) {
      yield AmountChangerMapper().mapResultToState(state, event.amountChanged);
    } else if (event is OnMaxButtonTap) {
      final double plantedBalance = state.plantedBalance?.amount ?? 0;
      final double maxAmount = plantedBalance - minPlanted ;
      yield AmountChangerMapper().mapResultToState(state, maxAmount.toString());
    } else if (event is OnUnplantSeedsButtonTap) {
      yield state.copyWith(pageState: PageState.loading, onFocus: false);
      final Result result = await UnplantSeedsUseCase().run(amount: state.unplantedInputAmount.amount);
      yield UnplantSeedsResultMapper().mapResultToState(state, result);
    }
  }
}
