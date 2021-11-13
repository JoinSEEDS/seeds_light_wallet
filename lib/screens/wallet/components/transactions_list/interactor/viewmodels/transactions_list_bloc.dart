import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/usecases/load_transactions_use_case.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_events.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/transactions_list_state.dart';

class TransactionsListBloc extends Bloc<TransactionsListEvent, TransactionsListState> {
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription? eventBusSubscription;

  TransactionsListBloc() : super(TransactionsListState.initial()) {
    _tickerSubscription = Stream.periodic(const Duration(seconds: 20), (x) => x).listen((counter) {
      add(OnTransactionDisplayTick(counter));
    });
    eventBusSubscription = eventBus.on<OnNewTransactionEventBus>().listen((event) async {
      await Future.delayed(const Duration(milliseconds: 500)); // the blockchain needs 0.5 seconds to process
      add(const OnLoadTransactionsList());
    });
  }

  @override
  Future<void> close() async {
    await _tickerSubscription?.cancel();
    await eventBusSubscription?.cancel();
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
    } else if (event is OnTransactionRowTapped) {
      yield state.copyWith(pageCommand: ShowTransactionDetails(event.transaction));
    } else if (event is ClearTransactionListPageComand) {
      yield state.copyWith();
    }
  }
}
