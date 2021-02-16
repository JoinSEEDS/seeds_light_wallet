import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class EditNameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnNameChanged extends EditNameEvent {
  final String name;

  OnNameChanged({@required this.name});

  @override
  String toString() => 'OnNameChanged { name: $name }';
}
