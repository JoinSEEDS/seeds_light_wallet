import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object> get props => [];
}

class OnPinChanged extends SecurityEvent {
  @override
  String toString() => 'OnPinChanged';
}

class OnBiometricsChanged extends SecurityEvent {
  @override
  String toString() => 'OnBiometricsChanged';
}
