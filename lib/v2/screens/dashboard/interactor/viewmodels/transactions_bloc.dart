import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/interactor/usecases/load_transactions_use_case.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_events.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(TransactionsState.initial());

  @override
  Stream<TransactionsState> mapEventToState(TransactionsEvent event) async* {
    if (event is LoadTransactionsEvent) {
      yield state.copyWith(
        isLoading: true,
      );

      final result = await LoadTransactionsUseCase().run();

      yield TransactionsStateMapper().mapResultToState(state, result);
    }
  }
}
