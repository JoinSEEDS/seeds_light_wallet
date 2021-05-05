import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class GuardiansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadGuardians extends GuardiansEvent {
  final String userName;

  LoadGuardians({required this.userName});

  @override
  String toString() => 'LoadGuardians: { userName: $userName }';
}
