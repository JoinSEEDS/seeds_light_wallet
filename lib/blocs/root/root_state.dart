part of 'root_bloc.dart';

class RootState extends Equatable {
  final BusEvent? busEvent;
  final InternetConnectionStatus internetConnectionStatus;

  const RootState({this.busEvent, required this.internetConnectionStatus});

  @override
  List<Object?> get props => [busEvent];

  RootState copyWith({BusEvent? busEvent, InternetConnectionStatus? internetConnectionStatus}) {
    return RootState(
      busEvent: busEvent,
      internetConnectionStatus: internetConnectionStatus ?? this.internetConnectionStatus,
    );
  }

  factory RootState.initial() {
    return const RootState(internetConnectionStatus: InternetConnectionStatus.connected);
  }
}
