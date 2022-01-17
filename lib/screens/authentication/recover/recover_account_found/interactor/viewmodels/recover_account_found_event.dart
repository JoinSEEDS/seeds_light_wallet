part of 'recover_account_found_bloc.dart';

abstract class RecoverAccountFoundEvent extends Equatable {
  const RecoverAccountFoundEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialData extends RecoverAccountFoundEvent {
  const FetchInitialData();

  @override
  String toString() => 'FetchInitialData';
}

class OnClaimAccountTapped extends RecoverAccountFoundEvent {
  const OnClaimAccountTapped();

  @override
  String toString() => 'OnClaimAccountTapped';
}

class OnCopyIconTapped extends RecoverAccountFoundEvent {
  const OnCopyIconTapped();

  @override
  String toString() => 'OnCopyIconTapped';
}

class OnRefreshTapped extends RecoverAccountFoundEvent {
  const OnRefreshTapped();

  @override
  String toString() => 'OnRefreshTapped';
}

class OnCancelProcessTapped extends RecoverAccountFoundEvent {
  const OnCancelProcessTapped();

  @override
  String toString() => 'OnCancelProcessTapped';
}

class ClearRecoverPageCommand extends RecoverAccountFoundEvent {
  const ClearRecoverPageCommand();

  @override
  String toString() => 'ClearRecoverPageCommand';
}

class StartCycleCountdown extends RecoverAccountFoundEvent {
  const StartCycleCountdown();

  @override
  String toString() => 'StartCycleCountdown';
}

class Tick extends RecoverAccountFoundEvent {
  final int count;

  const Tick(this.count);

  @override
  List<Object?> get props => [count];

  @override
  String toString() => 'Tick { $count }';
}
