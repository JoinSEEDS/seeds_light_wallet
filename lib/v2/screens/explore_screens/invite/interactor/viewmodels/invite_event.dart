import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class InviteEvent extends Equatable {
  const InviteEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends InviteEvent {
  const LoadUserBalance();
  @override
  String toString() => 'LoadUserBalance';
}

class OnAmountChange extends InviteEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { OnAmountChange: $amountChanged }';
}

class OnCreateInviteButtonTapped extends InviteEvent {
  const OnCreateInviteButtonTapped();
  @override
  String toString() => 'OnCreateInviteButtonTapped';
}

class OnShareInviteLinkButtonPressed extends InviteEvent {
  const OnShareInviteLinkButtonPressed();
  @override
  String toString() => 'OnShareInviteLinkButtonPressed';
}

class ClearInviteScreenPageCommand extends InviteEvent {
  const ClearInviteScreenPageCommand();
  @override
  String toString() => 'ClearInviteScreenPageCommand';
}
