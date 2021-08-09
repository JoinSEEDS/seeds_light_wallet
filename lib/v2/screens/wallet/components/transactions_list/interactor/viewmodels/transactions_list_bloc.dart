import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/usecases/load_transactions_use_case.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/v2/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_state.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
    
  StreamSubscription<int>? _tickerSubscription;
  
  TransactionsListBloc() : super(TransactionsListState.initial()) {
      _tickerSubscription = Stream.periodic(const Duration(seconds: 20), (x) => x).listen((counter) {
        add(OnTransactionDisplayTick(counter));
      });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TransactionsListState> mapEventToState(TransactionsListEvent event) async* {
    if (event is OnLoadTransactionsList) {
      yield state.copyWith(pageState: PageState.loading);

      final result = await LoadTransactionsUseCase().run();

      yield TransactionsListStateMapper().mapResultToState(state, result);
    } else if (event is OnTransactionDisplayTick) {
      yield state.copyWith(counter: event.count);
    }
  }
}
