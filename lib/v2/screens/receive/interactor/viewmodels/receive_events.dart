import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ReceiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoToInputSeeds extends ReceiveEvent {

  @override
  String toString() => 'goToInputSeeds';
}

class GoToMerchant extends ReceiveEvent {

  @override
  String toString() => 'GoToMerchant';
}

class ClearState extends ReceiveEvent {

  @override
  String toString() => 'ClearState';
}
