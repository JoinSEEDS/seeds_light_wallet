import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SendEnterDataPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSendDataArguments extends SendEnterDataPageEvent {
  @override
  String toString() => 'InitSendDataArguments: { InitSendDataArguments: }';
}

class OnAmountChange extends SendEnterDataPageEvent {
  final String amountChanged;

  OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { OnAmountChange: $amountChanged }';
}

class OnNextButtonTapped extends SendEnterDataPageEvent {
  @override
  String toString() => 'OnNextButtonTapped';
}

class OnSendButtonTapped extends SendEnterDataPageEvent {
  @override
  String toString() => 'OnSendButtonTapped';
}

class ClearPageCommand extends SendEnterDataPageEvent {
  @override
  String toString() => 'ClearPageCommand';
}
