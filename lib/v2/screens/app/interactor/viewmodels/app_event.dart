import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class ShouldShowNotificationBadge extends AppEvent {
  final bool value;
  const ShouldShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class ShouldShowGuardianRecoveryAlert extends AppEvent {
  final bool value;
  const ShouldShowGuardianRecoveryAlert({required this.value});
  @override
  String toString() => 'ShouldShowGuardianRecoveryAlert { value: $value }';
}

class BottomBarTapped extends AppEvent {
  final int index;
  const BottomBarTapped({required this.index});
  @override
  String toString() => 'BottomBarTapped { index: $index }';
}
