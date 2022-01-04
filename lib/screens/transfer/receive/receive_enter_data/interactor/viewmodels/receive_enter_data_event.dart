part of 'receive_enter_data_bloc.dart';

abstract class ReceiveEnterDataEvent extends Equatable {
  const ReceiveEnterDataEvent();

  @override
  List<Object> get props => [];
}

class LoadUserBalance extends ReceiveEnterDataEvent {
  const LoadUserBalance();

  @override
  String toString() => 'LoadUserBalance';
}

class OnAmountChange extends ReceiveEnterDataEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { amountChange: $amountChanged }';
}

class OnDescriptionChange extends ReceiveEnterDataEvent {
  final String description;

  const OnDescriptionChange({required this.description});

  @override
  String toString() => 'OnDescriptionChange: { description: $description }';
}

class OnNextButtonTapped extends ReceiveEnterDataEvent {
  const OnNextButtonTapped();

  @override
  String toString() => 'OnNextButtonTapped';
}

class ClearReceiveEnterDataState extends ReceiveEnterDataEvent {
  const ClearReceiveEnterDataState();

  @override
  String toString() => 'ClearPageState';
}
