part of 'root_bloc.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();

  @override
  List<Object> get props => [];
}

class OnRootBusEventRecived extends RootEvent {
  final BusEvent busEvent;

  const OnRootBusEventRecived(this.busEvent);

  @override
  List<Object> get props => [busEvent];

  @override
  String toString() => 'OnRootBusEventRecived { BusEvent: ${busEvent.runtimeType} }';
}

class OnConnectivityChanged extends RootEvent {
  const OnConnectivityChanged();

  @override
  String toString() => 'OnConnectivityChanged';
}

class ClearRootBusEvent extends RootEvent {
  const ClearRootBusEvent();

  @override
  String toString() => 'ClearRootBusEvent';
}
