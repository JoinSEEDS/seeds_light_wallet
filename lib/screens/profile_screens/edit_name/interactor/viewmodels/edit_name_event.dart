part of 'edit_name_bloc.dart';

abstract class EditNameEvent extends Equatable {
  const EditNameEvent();

  @override
  List<Object?> get props => [];
}

class OnNameChanged extends EditNameEvent {
  final String name;

  const OnNameChanged({required this.name});

  @override
  List<Object?> get props => [name];

  @override
  String toString() => 'OnNameChanged { name: $name }';
}

class SubmitName extends EditNameEvent {
  const SubmitName();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'SubmitName';
}

class ClearPageCommand extends EditNameEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}