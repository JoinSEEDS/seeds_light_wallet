import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class BalanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnBalanceUpdate extends BalanceEvent {

  OnBalanceUpdate();

  @override
  String toString() => 'OnBalanceUpdate';
}

