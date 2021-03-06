import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ScannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoNetworkCall extends ScannerEvent {
  final String todoParamName;

  TodoNetworkCall({@required this.todoParamName}) : assert(todoParamName != null);

  @override
  String toString() => 'TodoNetworkCall: { userName: $todoParamName }';
}
