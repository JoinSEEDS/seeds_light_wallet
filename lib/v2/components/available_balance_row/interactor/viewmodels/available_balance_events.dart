import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AvailableBalanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSendDataArguments extends AvailableBalanceEvent {
  @override
  String toString() => 'InitAmountEntryDataArguments: {}';
}

class ClearPageCommand extends AvailableBalanceEvent {
  @override
  String toString() => 'ClearPageCommand: {}';
}

class OnAmountChange extends AvailableBalanceEvent {
  final String amountChanged;

  OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange { OnAmountChange: $amountChanged }';
}

class OnCurrencySwitchButtonTapped extends AvailableBalanceEvent {
  @override
  String toString() => 'OnCurrencySwitchButtonTapped: {}';
}
