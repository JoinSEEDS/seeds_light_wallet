part of 'send_confirmation_bloc.dart';

abstract class SendConfirmationEvent extends Equatable {
  const SendConfirmationEvent();

  @override
  List<Object> get props => [];
}

class SendTransactionEvent extends SendConfirmationEvent {
  final RatesState rates;

  const SendTransactionEvent(this.rates);

  @override
  String toString() => 'SendTransactionEvent { rates: $rates }';
}
