import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

/// --- EVENTS
@immutable
abstract class SendConfirmationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSendConfirmationWithArguments extends SendConfirmationEvent {
  final SendConfirmationArguments arguments;

  InitSendConfirmationWithArguments({@required this.arguments}) : assert(arguments != null);

  @override
  String toString() => 'LoadSendConfirmation: { sendConfirmationArguments: $arguments }';
}

class SendTransactionEvent extends SendConfirmationEvent {

  /// accountName is the current logged in user account.
  SendTransactionEvent();

  @override
  String toString() => 'SendTransactionEvent: { SendTransactionEvent: }';
}
