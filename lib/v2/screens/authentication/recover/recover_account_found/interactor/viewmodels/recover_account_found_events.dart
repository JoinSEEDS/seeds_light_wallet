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

class OnClaimAccountTap extends RecoverAccountFoundEvent {
  @override
  String toString() => 'OnClaimAccountTap';
}

class OnCopyIconTap extends RecoverAccountFoundEvent {
  @override
  String toString() => 'OnCopyIconTab';
}

class OnRefreshTap extends RecoverAccountFoundEvent {
  @override
  String toString() => 'OnRefreshTap';
}

class OnCancelProcessTap extends RecoverAccountFoundEvent {
  @override
  String toString() => 'OnCancelProcessTap';
}

class ClearRecoverPageCommand extends RecoverAccountFoundEvent {
  @override
  String toString() => 'ClearRecoverPageCommand';

  const ClearRecoverPageCommand();
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