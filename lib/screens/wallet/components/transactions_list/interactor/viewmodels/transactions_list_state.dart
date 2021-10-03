import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class TransactionsListState extends Equatable {
  final PageState pageState;
  final List<TransactionModel> transactions;
  final int counter;
  bool get isLoadingNoData => pageState == PageState.loading && transactions.isEmpty;

  const TransactionsListState({
    required this.pageState,
    required this.transactions,
    required this.counter,
  });

  @override
  List<Object> get props => [pageState, transactions, counter];

  TransactionsListState copyWith({
    PageState? pageState,
    List<TransactionModel>? transactions,
    int? counter,
  }) {
    return TransactionsListState(
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
