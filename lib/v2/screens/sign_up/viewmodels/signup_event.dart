part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

/// Claim Invite Events
class OnInviteCodeChanged extends SignupEvent {
  final String inviteCode;

  const OnInviteCodeChanged({required this.inviteCode});

  @override
  String toString() => 'OnInviteCodeChanged { inviteCode: $inviteCode }';
}

class OnQRScanned extends SignupEvent {
  final String scannedLink;

  const OnQRScanned(this.scannedLink);

  @override
  String toString() => 'OnQRScanned { scannedLink: $scannedLink }';
}

class ClaimInviteOnNextTapped extends SignupEvent {
  @override
  String toString() => 'ClaimInviteOnNextTapped';
}

/// Display Name Events
class DisplayNameOnNextTapped extends SignupEvent {
  final String displayName;

  const DisplayNameOnNextTapped(this.displayName);

  @override
  String toString() => 'DisplayNameOnNextTapped { displayName: $displayName }';
}

/// Create Username Events
class OnUsernameChanged extends SignupEvent {
  final String userName;

  const OnUsernameChanged({required this.userName});

  @override
  String toString() => 'OnUsernameChanged { userName: $userName }';
}

class CreateUsernameOnNextTapped extends SignupEvent {
  @override
  String toString() => 'CreateUsernameOnNextTapped';
}

/// Add Phone Number Events

/// Common Events
class OnBackPressed extends SignupEvent {
  @override
  String toString() => 'NavigateBack';
}
