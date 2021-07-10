import 'package:equatable/equatable.dart';

abstract class TransactionsListEvent extends Equatable {}

class LoadTransactionsListEvent extends TransactionsListEvent {
  LoadTransactionsListEvent();

  @override
  List<Object> get props => [];
}
