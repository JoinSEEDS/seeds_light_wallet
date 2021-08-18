import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class InviteGuardiansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnSendInviteTapped extends InviteGuardiansEvent {
  @override
  String toString() => 'OnSendInviteTapped';
}

class InviteGuardianClearPageCommand extends InviteGuardiansEvent {
  @override
  String toString() => 'InviteGuardianClearPageCommand';
}
