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
