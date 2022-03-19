part of 'root_bloc.dart';

class RootState extends Equatable {
  final BusEvent? busEvent;

  const RootState({this.busEvent});

  @override
  List<Object?> get props => [busEvent];

  RootState copyWith({BusEvent? busEvent}) {
    return RootState(busEvent: busEvent);
  }

  factory RootState.initial() {
    return const RootState();
  }
}
