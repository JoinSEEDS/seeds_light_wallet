import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UnplantSeedsEvent extends Equatable {
  const UnplantSeedsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserPlantedBalance extends UnplantSeedsEvent {
  const LoadUserPlantedBalance();

  @override
  String toString() => 'LoadUserPlantedBalance';
}

class OnAmountChange extends UnplantSeedsEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange { OnAmountChange: $amountChanged }';
}

class OnMaxButtonTap extends UnplantSeedsEvent {
  final String maxAmount;

  const OnMaxButtonTap({required this.maxAmount});

  @override
  String toString() => 'OnMaxButtonTap { OnAmountChange: $maxAmount }';
}

class OnUnplantSeedsButtonTap extends UnplantSeedsEvent {
  @override
  String toString() => 'OnUnplantSeedsButtonTap';
}
