import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class VoteEvent extends Equatable {
  const VoteEvent();
  @override
  List<Object> get props => [];
}

class StartCycleCountdown extends VoteEvent {
  @override
  String toString() => 'StartCycleCountdown';
}

class Tick extends VoteEvent {
  final int timer;

  const Tick(this.timer);

  @override
  List<Object> get props => [timer];

  @override
  String toString() => 'Tick { remaining seconds: $timer }';
}
