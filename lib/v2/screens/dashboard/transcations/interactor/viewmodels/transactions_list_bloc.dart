import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/transcations/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/v2/screens/dashboard/transcations/interactor/viewmodels/transactions_list_state.dart';
import 'package:seeds/v2/screens/dashboard/transcations/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/transcations/interactor/usecases/load_transactions_use_case.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
  TransactionsListBloc() : super(TransactionsListState.initial());

  @override
  Stream<TransactionsListState> mapEventToState(TransactionsListEvent event) async* {
    if (event is LoadTransactionsListEvent) {

      yield state.copyWith(pageState: PageState.loading);

      final result = await LoadTransactionsUseCase().run();

      yield TransactionsListStateMapper().mapResultToState(state, result);
      
    }
  }
}
