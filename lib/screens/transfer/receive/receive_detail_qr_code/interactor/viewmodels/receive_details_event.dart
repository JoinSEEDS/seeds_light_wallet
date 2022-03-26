part of 'receive_details_bloc.dart';

abstract class ReceiveDetailsEvent extends Equatable {
  const ReceiveDetailsEvent();

  @override
  List<Object> get props => [];
}

class OnPaymentReceived extends ReceiveDetailsEvent {
  const OnPaymentReceived();

  @override
  String toString() => 'OnPaymentReceived';
}

class OnPollCheckPayment extends ReceiveDetailsEvent {
  const OnPollCheckPayment();

  @override
  String toString() => 'OnPollCheckPayment';
}

class OnCheckPaymentButtonPressed extends ReceiveDetailsEvent {
  const OnCheckPaymentButtonPressed();

  @override
  String toString() => 'OnCheckPaymentButtonPressed';
}
