import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object> get props => [];
}

class SetUpInitialValues extends SecurityEvent {
  const SetUpInitialValues();
  @override
  String toString() => 'SetUpInitialValues';
}

class ShowNotificationBadge extends SecurityEvent {
  final bool value;
  const ShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShowNotificationBadge { value: $value }';
}

class OnGuardiansCardTapped extends SecurityEvent {
  const OnGuardiansCardTapped();
  @override
  String toString() => 'OnGuardiansCardTapped';
}

class OnPasscodeChanged extends SecurityEvent {
  const OnPasscodeChanged();
  @override
  String toString() => 'OnPasscodeChanged';
}

class OnBiometricsChanged extends SecurityEvent {
  const OnBiometricsChanged();
  @override
  String toString() => 'OnBiometricsChanged';
}
