import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';

/// --- EVENTS
@immutable
abstract class SendConfirmationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSendConfirmationWithArguments extends SendConfirmationEvent {
  @override
  String toString() => 'LoadSendConfirmation: { sendConfirmationArguments: }';
}

class SendTransactionEvent extends SendConfirmationEvent {
  final RatesState rates;

  SendTransactionEvent(this.rates);

  @override
  String toString() => 'SendTransactionEvent: { SendTransactionEvent: }';
}
