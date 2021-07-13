import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/interactor/usecases/load_transactions_use_case.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/v2/screens/wallet/components/transactions/interactor/viewmodels/transactions_list_state.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
  TransactionsListBloc() : super(TransactionsListState.initial());

  @override
  Stream<TransactionsListState> mapEventToState(TransactionsListEvent event) async* {
    if (event is OnLoadTransactionsList) {
      yield state.copyWith(pageState: PageState.loading);

      final result = await LoadTransactionsUseCase().run();

      yield TransactionsListStateMapper().mapResultToState(state, result);
    }
  }
}
