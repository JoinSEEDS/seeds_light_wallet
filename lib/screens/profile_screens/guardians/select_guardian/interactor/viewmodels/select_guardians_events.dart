import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';

/// --- EVENTS
@immutable
abstract class SelectGuardiansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnUserSelected extends SelectGuardiansEvent {
  final MemberModel user;

  OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { OnUserSelected: $user }';
}

class OnUserRemoved extends SelectGuardiansEvent {
  final MemberModel user;

  OnUserRemoved(this.user);

  @override
  String toString() => 'OnUserRemoved: { OnUserRemoved: $user }';
}

class ClearPageCommand extends SelectGuardiansEvent {
  @override
  String toString() => 'ClearPageCommand';
}
