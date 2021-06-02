import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/receive_screens/receive_enter_data/interactor/viewmodels/receive_enter_data_events.dart';
import 'package:seeds/v2/screens/receive_screens/receive_enter_data/interactor/viewmodels/receive_enter_data_state.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'mappers/user_balance_state_mapper.dart';

/// --- BLOC
class ReceiveEnterDataBloc extends Bloc<ReceiveEnterDataEvents, ReceiveEnterDataState> {
  ReceiveEnterDataBloc(RatesState rates) : super(ReceiveEnterDataState.initial(rates));

  @override
  Stream<ReceiveEnterDataState> mapEventToState(ReceiveEnterDataEvents event) async* {
    if (event is LoadUserBalance) {
      yield state.copyWith(pageState: PageState.success);
      Result result = await GetAvailableBalanceUseCase().run();
      yield UserBalanceStateMapper().mapResultToState(state, result, state.ratesState);
    }
    if (event is OnAmountChange) {
      double parsedQuantity = double.tryParse(event.amountChanged) ?? 0;

      if (parsedQuantity > 0) {
        yield state.copyWith(isNextButtonEnabled: true);
      } else {
        yield state.copyWith(isNextButtonEnabled: false);
      }
    }
    if (event is OnDescriptionChange) {
      yield state.copyWith(description: event.description);
    }
    if (event is OnNextButtonTapped) {
      //Create Receive
      //if success
      yield state.copyWith(pageCommand: NavigateToReceiveDetails());
      //if failure
      yield state.copyWith(pageCommand: ShowTransactionFailSnackBar());
    }
  }
}
