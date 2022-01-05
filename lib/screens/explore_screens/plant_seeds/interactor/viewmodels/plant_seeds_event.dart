part of 'plant_seeds_bloc.dart';

abstract class PlantSeedsEvent extends Equatable {
  const PlantSeedsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends PlantSeedsEvent {
  const LoadUserBalance();
  @override
  String toString() => 'LoadUserBalance';
}

class OnAmountChange extends PlantSeedsEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { OnAmountChange: $amountChanged }';
}

class OnPlantSeedsButtonTapped extends PlantSeedsEvent {
  const OnPlantSeedsButtonTapped();
  @override
  String toString() => 'OnPlantSeedsButtonTapped';
}
