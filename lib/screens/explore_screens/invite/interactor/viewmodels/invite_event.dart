import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

/// --- EVENTS
@immutable
abstract class InviteEvent extends Equatable {
  const InviteEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends InviteEvent {
  final TokenParameters tokenParameters;
  const LoadUserBalance(this.tokenParameters);
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
