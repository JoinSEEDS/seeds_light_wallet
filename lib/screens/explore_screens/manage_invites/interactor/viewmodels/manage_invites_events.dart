import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ManageInvitesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadInvites extends ManageInvitesEvent {
  @override
  String toString() => 'LoadInvites';
}

class OnCancelInviteTapped extends ManageInvitesEvent {
  final String inviteHash;

  OnCancelInviteTapped(this.inviteHash);

  @override
  String toString() => 'OnCancelInviteTapped: $inviteHash';
}
