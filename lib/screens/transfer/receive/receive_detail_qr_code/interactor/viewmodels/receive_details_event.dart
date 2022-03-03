part of 'receive_details_bloc.dart';

abstract class ReceiveDetailsEvent extends Equatable {
  const ReceiveDetailsEvent();

  @override
  List<Object> get props => [];
}

class OnPaymentReceived extends ReceiveDetailsEvent {
  final PushNotificationData data;

  const OnPaymentReceived(this.data);

  @override
  String toString() => 'OnPaymentReceived';
}
