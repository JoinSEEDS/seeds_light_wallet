part of 'manage_invites_bloc.dart';

abstract class ManageInvitesEvent extends Equatable {
  const ManageInvitesEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadInvites extends ManageInvitesEvent {
  const OnLoadInvites();

  @override
  String toString() => 'OnLoadInvites';
}

class OnCancelInviteTapped extends ManageInvitesEvent {
  final String inviteHash;

  const OnCancelInviteTapped(this.inviteHash);

  @override
  String toString() => 'OnCancelInviteTapped: $inviteHash';
}
