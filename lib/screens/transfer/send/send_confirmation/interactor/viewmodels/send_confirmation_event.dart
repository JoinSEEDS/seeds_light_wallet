part of 'send_confirmation_bloc.dart';

abstract class SendConfirmationEvent extends Equatable {
  const SendConfirmationEvent();

  @override
  List<Object?> get props => [];
}

class OnInitValidations extends SendConfirmationEvent {
  const OnInitValidations();

  @override
  String toString() => ' OnInitValidations';
}

class OnSendTransactionButtonPressed extends SendConfirmationEvent {
  final RatesState rates;

  const OnSendTransactionButtonPressed(this.rates);

  @override
  String toString() => 'OnSendTransactionButtonPressed { rates: $rates }';
}

class OnAuthorizationFailure extends SendConfirmationEvent {
  final RatesState rates;
  final BuildContext context;

  const OnAuthorizationFailure(this.rates, {required this.context});

  @override
  String toString() => 'OnAuthorizationFailure { rates: $rates }';
}
