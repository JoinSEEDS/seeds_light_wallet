import 'package:equatable/equatable.dart';

/// --- STATES
enum ReceiveStates { initial, navigateToInputSeeds, navigateToMerchant }

class ReceiveState extends Equatable {
  final ReceiveStates receiveStates;

  const ReceiveState({
    required this.receiveStates,
  });

  @override
  List<Object?> get props => [
        receiveStates,
      ];

  ReceiveState copyWith({
    ReceiveStates? receiveStates,
  }) {
    return ReceiveState(
      receiveStates: receiveStates ?? this.receiveStates,
    );
  }

  factory ReceiveState.initial() {
    return const ReceiveState(receiveStates: ReceiveStates.initial);
  }
}
