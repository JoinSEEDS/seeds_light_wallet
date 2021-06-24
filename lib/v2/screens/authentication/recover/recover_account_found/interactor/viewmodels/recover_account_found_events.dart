import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class RecoverAccountFoundEvent extends Equatable {
  const RecoverAccountFoundEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialData extends RecoverAccountFoundEvent {
  @override
  String toString() => 'FetchInitialData';
}

class StartCycleCountdown extends RecoverAccountFoundEvent {
  @override
  String toString() => 'StartCycleCountdown';
}

class Tick extends RecoverAccountFoundEvent {
  final int timer;

  const Tick(this.timer);

  @override
  List<Object> get props => [timer];

  @override
  String toString() => 'Tick { remaining seconds: $timer }';
}