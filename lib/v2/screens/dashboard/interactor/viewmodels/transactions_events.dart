import 'package:equatable/equatable.dart';

abstract class TransactionsEvent extends Equatable {}

class LoadTransactionsEvent extends TransactionsEvent {
  LoadTransactionsEvent();

  @override
  List<Object> get props => [];
}
