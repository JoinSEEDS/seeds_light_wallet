part of 'select_guardians_bloc.dart';

abstract class SelectGuardiansEvent extends Equatable {
  const SelectGuardiansEvent();

  @override
  List<Object?> get props => [];
}

class OnUserSelected extends SelectGuardiansEvent {
  final ProfileModel user;

  const OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { OnUserSelected: $user }';
}

class OnUserRemoved extends SelectGuardiansEvent {
  final ProfileModel user;

  const OnUserRemoved(this.user);

  @override
  String toString() => 'OnUserRemoved: { OnUserRemoved: $user }';
}

class ClearPageCommand extends SelectGuardiansEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
