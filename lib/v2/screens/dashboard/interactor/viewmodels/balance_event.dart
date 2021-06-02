import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class BalanceEvent extends Equatable {
  const BalanceEvent();
  @override
  List<Object> get props => [];
}

class OnLoadBalance extends BalanceEvent {

  const OnLoadBalance();

  @override
  String toString() => 'OnLoadBalance';
}

