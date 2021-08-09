import 'package:equatable/equatable.dart';

abstract class TransactionsListEvent extends Equatable {}

class OnLoadTransactionsList extends TransactionsListEvent {
  OnLoadTransactionsList();

  @override
  String toString() => 'OnLoadTransactionsList';

  @override
  List<Object> get props => [];
}

class OnTransactionDisplayTick extends TransactionsListEvent {
  final int count;
  
  OnTransactionDisplayTick(this.count);

  @override
  String toString() => 'OnTick';

  @override
  List<Object> get props => [count];
}