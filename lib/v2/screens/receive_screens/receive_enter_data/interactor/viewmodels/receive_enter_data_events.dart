import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ReceiveEnterDataEvents extends Equatable {
  const ReceiveEnterDataEvents();

  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends ReceiveEnterDataEvents {
  const LoadUserBalance();

  @override
  String toString() => 'LoadUserBalance';
}

class OnAmountChange extends ReceiveEnterDataEvents {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { amountChange: $amountChanged }';
}

class OnDescriptionChange extends ReceiveEnterDataEvents {
  final String description;

  const OnDescriptionChange({required this.description});

  @override
  String toString() => 'OnDescriptionChange: { description: $description }';
}

class OnNextButtonTapped extends ReceiveEnterDataEvents {
  const OnNextButtonTapped();

  @override
  String toString() => 'OnNextButtonTapped';
}
