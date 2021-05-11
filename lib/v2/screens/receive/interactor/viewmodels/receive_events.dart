import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ReceiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TapInputSeedsCard extends ReceiveEvent {

  @override
  String toString() => 'TapInputSeedsCard';
}

class TapMerchantCard extends ReceiveEvent {

  @override
  String toString() => 'TapMerchantCard';
}

class ClearState extends ReceiveEvent {

  @override
  String toString() => 'ClearState';
}
