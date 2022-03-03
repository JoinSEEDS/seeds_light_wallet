import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/load_transactions_use_case.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/mappers/transactions_state_mapper.dart';
import 'package:seeds/screens/wallet/components/transactions_list/interactor/viewmodels/page_commands.dart';

part 'transactions_list_event.dart';
part 'transactions_list_state.dart';

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
    on<OnLoadTransactionsList>(_onLoadTransactionsList);
    on<OnTransactionDisplayTick>((event, emit) => emit(state.copyWith(counter: event.count)));
    on<OnTransactionRowTapped>(_onTransactionRowTapped);
    on<ClearTransactionListPageComand>((_, emit) => emit(state.copyWith()));
  }

  @override
  Future<void> close() async {
    await _tickerSubscription?.cancel();
    await eventBusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTransactionsList(OnLoadTransactionsList event, Emitter<TransactionsListState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await LoadTransactionsUseCase().run();
    emit(TransactionsListStateMapper().mapResultToState(state, result));
  }

  void _onTransactionRowTapped(OnTransactionRowTapped event, Emitter<TransactionsListState> emit) {
    emit(state.copyWith(pageCommand: ShowTransactionDetails(event.transaction)));
  }
}
