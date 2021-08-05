import 'package:equatable/equatable.dart';

abstract class TransactionsListEvent extends Equatable {}

class OnLoadTransactionsList extends TransactionsListEvent {
  OnLoadTransactionsList();

  @override
  String toString() => 'OnLoadTransactionsList';

  @override
  List<Object> get props => [];
}
