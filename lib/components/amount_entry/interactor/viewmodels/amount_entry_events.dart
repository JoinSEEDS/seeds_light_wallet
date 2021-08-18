import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AmountEntryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSendDataArguments extends AmountEntryEvent {
  @override
  String toString() => 'InitAmountEntryDataArguments: {}';
}

class ClearPageCommand extends AmountEntryEvent {
  @override
  String toString() => 'ClearPageCommand: {}';
}

class OnAmountChange extends AmountEntryEvent {
  final String amountChanged;

  OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange { OnAmountChange: $amountChanged }';
}

class OnCurrencySwitchButtonTapped extends AmountEntryEvent {
  @override
  String toString() => 'OnCurrencySwitchButtonTapped: {}';
}
