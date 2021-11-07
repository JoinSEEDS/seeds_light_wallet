import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DelegatorEvent extends Equatable {
  const DelegatorEvent();

  @override
  List<Object> get props => [];
}

class LoadDelegatorData extends DelegatorEvent {
  const LoadDelegatorData();

  @override
  String toString() => 'LoadDelegateData';
}

class ClearPageCommand extends DelegatorEvent {
  @override
  String toString() => 'ClearPageCommand';
}
