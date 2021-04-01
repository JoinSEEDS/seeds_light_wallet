import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
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
  final FiatRateModel rates;

  SendTransactionEvent(this.rates);

  @override
  String toString() => 'SendTransactionEvent: { SendTransactionEvent: }';
}
