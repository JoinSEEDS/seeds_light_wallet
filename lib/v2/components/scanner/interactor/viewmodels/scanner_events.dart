import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ScannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShowError extends ScannerEvent {
  final String error;

  ShowError({@required this.error}) : assert(error != null);

  @override
  String toString() => 'ShowError: { error: $error }';
}

class ShowLoading extends ScannerEvent {}

class Scan extends ScannerEvent {}
