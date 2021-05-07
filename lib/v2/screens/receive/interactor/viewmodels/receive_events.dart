import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ReceiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TabInputSeedsCard extends ReceiveEvent {

  @override
  String toString() => 'TabInputSeedsCard';
}

class TabMerchantCard extends ReceiveEvent {

  @override
  String toString() => 'TabMerchantCard';
}

class ClearState extends ReceiveEvent {

  @override
  String toString() => 'ClearState';
}
