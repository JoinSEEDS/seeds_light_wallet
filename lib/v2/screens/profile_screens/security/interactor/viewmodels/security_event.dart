import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object> get props => [];
}

class ShowNotificationBadge extends SecurityEvent {
  final bool value;
  const ShowNotificationBadge({@required this.value}) : assert(value != null);
  @override
  String toString() => 'ShowNotificationBadge { value: $value }';
}

class OnGuardiansCardTapped extends SecurityEvent {
  const OnGuardiansCardTapped();
  @override
  String toString() => 'OnGuardiansCardTapped';
}

class OnPinChanged extends SecurityEvent {
  const OnPinChanged();
  @override
  String toString() => 'OnPinChanged';
}

class OnBiometricsChanged extends SecurityEvent {
  const OnBiometricsChanged();
  @override
  String toString() => 'OnBiometricsChanged';
}
