part of 'invite_guardians_bloc.dart';

abstract class InviteGuardiansEvent extends Equatable {
  const InviteGuardiansEvent();

  @override
  List<Object?> get props => [];
}

class OnSendInviteTapped extends InviteGuardiansEvent {
  const OnSendInviteTapped();

  @override
  String toString() => 'OnSendInviteTapped';
}

class InviteGuardianClearPageCommand extends InviteGuardiansEvent {
  const InviteGuardianClearPageCommand();

  @override
  String toString() => 'InviteGuardianClearPageCommand';
}
