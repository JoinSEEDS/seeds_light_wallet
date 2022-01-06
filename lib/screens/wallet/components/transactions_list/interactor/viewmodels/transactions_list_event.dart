part of 'transactions_list_bloc.dart';

abstract class TransactionsListEvent extends Equatable {
  const TransactionsListEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadTransactionsList extends TransactionsListEvent {
  const OnLoadTransactionsList();

  @override
  String toString() => 'OnLoadTransactionsList';

  @override
  List<Object?> get props => [];
}

class OnTransactionDisplayTick extends TransactionsListEvent {
  final int count;

  const OnTransactionDisplayTick(this.count);

  @override
  String toString() => 'OnTick';

  @override
  List<Object?> get props => [count];
}

class OnTransactionRowTapped extends TransactionsListEvent {
  final TransactionModel transaction;

  const OnTransactionRowTapped(this.transaction);

  @override
  String toString() => 'OnTransactionRowTapped { transaction: $transaction }';

  @override
  List<Object?> get props => [transaction];
}

class ClearTransactionListPageComand extends TransactionsListEvent {
  const ClearTransactionListPageComand();

  @override
  String toString() => 'ClearTransactionListPageComand';
}
