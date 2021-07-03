import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

class TransactionsState extends Equatable {
  final bool isLoading;
  final List<TransactionModel> transactions;

  const TransactionsState({
    required this.isLoading,
    required this.transactions,
  });

  @override
  List<Object> get props => [
        transactions,
        isLoading,
      ];

  TransactionsState copyWith({
    isLoading,
    transactions,
  }) {
    return TransactionsState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
    );
  }

  factory TransactionsState.initial() {
    return const TransactionsState(
      isLoading: false,
      transactions: [],
    );
  }
}
