import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SendConfirmationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSendConfirmation extends SendConfirmationEvent {
  final String userName;

  LoadSendConfirmation({@required this.userName}) : assert(userName != null);

  @override
  String toString() => 'LoadSendConfirmation: { userName: $userName }';
}
