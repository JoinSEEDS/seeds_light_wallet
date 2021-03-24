import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SendPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShowError extends SendPageEvent {
  final String error;

  ShowError({@required this.error}) : assert(error != null);

  @override
  String toString() => 'ShowError: { error: $error }';
}

class ExecuteScanResult extends SendPageEvent {
  final String scanResult;

  ExecuteScanResult({@required this.scanResult}) : assert(scanResult != null);

  @override
  String toString() => 'ExecuteScanResult: { scanResult: $scanResult }';
}
