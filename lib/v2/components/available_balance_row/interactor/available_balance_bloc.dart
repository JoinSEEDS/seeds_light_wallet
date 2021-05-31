import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/available_balance_row/interactor/viewmodels/available_balance_events.dart';
import 'package:seeds/v2/components/available_balance_row/interactor/viewmodels/available_balance_state.dart';
import 'package:seeds/v2/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/v2/components/available_balance_row/mappers/available_balance_mapper.dart';

import 'package:seeds/v2/domain-shared/shared_use_cases/get_available_balance_use_case.dart';




class AvailableBalanceBloc extends Bloc<AvailableBalanceEvent, AvailableBalanceState> {
  AvailableBalanceBloc(RatesState rates) : super(AvailableBalanceState.initial(rates));

  @override
  Stream<AvailableBalanceState> mapEventToState(AvailableBalanceEvent event) async* {
    if (event is InitSendDataArguments) {

      Result result = await GetAvailableBalanceUseCase().run();
      //
      yield AvailableBalanceStateMapper().mapResultToState(state, result, state.ratesState);
      // yield AvailableBalanceStateMapper().mapResultToState();
      // yield SendEnterDataStateMapper().mapResultToState(state, result, state.ratesState, "0");
    }
  }

}
