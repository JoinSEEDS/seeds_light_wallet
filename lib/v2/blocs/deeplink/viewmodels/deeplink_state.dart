import 'package:equatable/equatable.dart';

/// --- STATES
class DeeplinkState extends Equatable {
  const DeeplinkState();

  @override
  List<Object?> get props => [];

  DeeplinkState copyWith() {
    return const DeeplinkState();
  }

  factory DeeplinkState.initial() {
    return const DeeplinkState();
  }
}
