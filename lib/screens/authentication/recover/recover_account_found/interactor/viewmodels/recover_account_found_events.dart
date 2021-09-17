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
  final int count;

  const Tick(this.count);

  @override
  List<Object> get props => [count];

  @override
  String toString() => 'Tick { $count }';
}
