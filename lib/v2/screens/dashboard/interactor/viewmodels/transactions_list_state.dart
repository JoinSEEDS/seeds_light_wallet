import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class TransactionsListState extends Equatable {
  final PageState pageState;
  final List<TransactionModel> transactions;
  bool get isLoadingNoData => pageState == PageState.loading && transactions.isEmpty;

  const TransactionsListState({
    required this.pageState,
    required this.transactions,
  });

  @override
  List<Object> get props => [pageState, transactions];

  TransactionsListState copyWith({pageState, transactions}) {
    return TransactionsListState(
      pageState: pageState ?? this.pageState,
      transactions: transactions ?? this.transactions,
    );
  }

  factory TransactionsListState.initial() {
    return const TransactionsListState(
      pageState: PageState.initial,
      transactions: [],
    );
  }
}
