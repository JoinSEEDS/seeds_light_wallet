import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DelegateEvent extends Equatable {
  const DelegateEvent();

  @override
  List<Object> get props => [];
}

class LoadDelegateData extends DelegateEvent {
  const LoadDelegateData();

  @override
  String toString() => 'LoadDelegateData';
}

class RemoveDelegate extends DelegateEvent {
  const RemoveDelegate();

  @override
  String toString() => 'RemoveDelegate';
}

class InitOnboardingDelegate extends DelegateEvent {
  const InitOnboardingDelegate();

  @override
  String toString() => 'InitOnboardingDelegate';
}

class ClearPageCommand extends DelegateEvent {
  @override
  String toString() => 'ClearPageCommand';
}
