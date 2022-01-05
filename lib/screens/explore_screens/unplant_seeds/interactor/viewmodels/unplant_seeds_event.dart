part of 'unplant_seeds_bloc.dart';

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

  const OnAmountChange(this.amountChanged);

  @override
  String toString() => 'OnAmountChange { OnAmountChange: $amountChanged }';
}

class OnMaxButtonTapped extends UnplantSeedsEvent {
  final String maxAmount;

  const OnMaxButtonTapped(this.maxAmount);

  @override
  String toString() => 'OnMaxButtonTapped { OnAmountChange: $maxAmount }';
}

class OnUnplantSeedsButtonTapped extends UnplantSeedsEvent {
  const OnUnplantSeedsButtonTapped();

  @override
  String toString() => 'OnUnplantSeedsButtonTapped';
}

class OnClaimButtonTapped extends UnplantSeedsEvent {
  const OnClaimButtonTapped();

  @override
  String toString() => 'OnClaimButtonTaped';
}
