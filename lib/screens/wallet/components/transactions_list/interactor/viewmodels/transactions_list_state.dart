import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class TransactionsListState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final List<TransactionModel> transactions;
  final int counter;
  bool get isLoadingNoData => pageState == PageState.loading && transactions.isEmpty;

  const TransactionsListState({
    this.pageCommand,
    required this.pageState,
    required this.transactions,
    required this.counter,
  });

  @override
  List<Object?> get props => [pageCommand, pageState, transactions, counter];

  TransactionsListState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    List<TransactionModel>? transactions,
    int? counter,
  }) {
    return TransactionsListState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      transactions: transactions ?? this.transactions,
      counter: counter ?? this.counter,
    );
  }

  factory TransactionsListState.initial() {
    return const TransactionsListState(
      pageState: PageState.initial,
      transactions: [],
      counter: 0,
    );
  }
}
