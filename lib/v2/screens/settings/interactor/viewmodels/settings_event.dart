import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadProfile extends SettingsEvent {
  @override
  String toString() => 'LoadProfile';
}

class OnNameChanged extends SettingsEvent {
  final String name;

  const OnNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'OnNameChanged { name: $name }';
}
