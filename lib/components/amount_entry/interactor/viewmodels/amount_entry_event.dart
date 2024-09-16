part of 'amount_entry_bloc.dart';

abstract class AmountEntryEvent extends Equatable {
  const AmountEntryEvent();

  @override
  List<Object?> get props => [];
}

class InitSendDataArguments extends AmountEntryEvent {
  const InitSendDataArguments();

  @override
  String toString() => 'InitAmountEntryDataArguments';
}

class ClearAmountEntryPageCommand extends AmountEntryEvent {
  const ClearAmountEntryPageCommand();

  @override
  String toString() => 'ClearAmountEntryPageCommand';
}

class OnAmountChange extends AmountEntryEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange { OnAmountChange: $amountChanged }';
}

class OnCurrencySwitchButtonTapped extends AmountEntryEvent {
  const OnCurrencySwitchButtonTapped();

  @override
  String toString() => 'OnCurrencySwitchButtonTapped';
}

class OnPushAmount extends AmountEntryEvent {
  final String amountChanged;

  const OnPushAmount({required this.amountChanged});

  @override
  String toString() => 'OnPushAmount { OnPushAmount: $amountChanged }';
}
