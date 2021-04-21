import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class ShowNotificationBadge extends AppEvent {
  final bool value;
  const ShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShowNotificationBadge { value: $value }';
}

class BottomBarTapped extends AppEvent {
  final int index;
  const BottomBarTapped({required this.index});
  @override
  String toString() => 'BottomBarTapped { index: $index }';
}
