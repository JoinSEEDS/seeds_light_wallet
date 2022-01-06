part of 'delegates_bloc.dart';

abstract class DelegatesEvent extends Equatable {
  const DelegatesEvent();

  @override
  List<Object?> get props => [];
}

class LoadDelegatesData extends DelegatesEvent {
  const LoadDelegatesData();

  @override
  String toString() => 'LoadDelegatesData';
}

class RemoveDelegate extends DelegatesEvent {
  const RemoveDelegate();

  @override
  String toString() => 'RemoveDelegate';
}

class InitOnboardingDelegate extends DelegatesEvent {
  const InitOnboardingDelegate();

  @override
  String toString() => 'InitOnboardingDelegate';
}

class OnRemoveDelegateTapped extends DelegatesEvent {
  const OnRemoveDelegateTapped();

  @override
  String toString() => 'OnRemoveDelegateTapped';
}

class ClearDelegatesPageCommand extends DelegatesEvent {
  const ClearDelegatesPageCommand();

  @override
  String toString() => 'ClearDelegatesPageCommand';
}
