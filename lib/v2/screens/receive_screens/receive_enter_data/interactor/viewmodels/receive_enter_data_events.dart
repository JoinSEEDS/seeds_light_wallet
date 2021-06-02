import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ReceiveEnterDataEvents extends Equatable {
  const ReceiveEnterDataEvents();
  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends ReceiveEnterDataEvents {
  const LoadUserBalance();
  @override
  String toString() => 'LoadUserBalance';
}

class OnAmountChange extends ReceiveEnterDataEvents {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { OnAmountChange: $amountChanged }';
}

class OnCreateInviteButtonTapped extends ReceiveEnterDataEvents {
  const OnCreateInviteButtonTapped();
  @override
  String toString() => 'OnCreateInviteButtonTapped';
}

class OnShareInviteLinkButtonPressed extends ReceiveEnterDataEvents {
  const OnShareInviteLinkButtonPressed();
  @override
  String toString() => 'OnShareInviteLinkButtonPressed';
}
