import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class SetUpInitialValues extends AppEvent {
  const SetUpInitialValues();
  @override
  String toString() => 'SetUpInitialValues';
}

class ShowNotificationBadge extends AppEvent {
  final bool value;
  const ShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShowNotificationBadge { value: $value }';
}

class BottomTapped extends AppEvent {
  final int index;
  const BottomTapped({required this.index});

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'BottomTapped { index: $index }';
}
