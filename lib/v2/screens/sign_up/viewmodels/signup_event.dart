part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

/// Claim Invite Events
class ValidateInviteCode extends SignupEvent {
  final String inviteCode;

  const ValidateInviteCode({required this.inviteCode});

  @override
  String toString() => 'ValidateInviteCode event { inviteCode: $inviteCode }';
}

class UnpackScannedLink extends SignupEvent {
  final String scannedLink;

  const UnpackScannedLink(this.scannedLink);

  @override
  String toString() => 'UnpackScannedLink event { scannedLink: $scannedLink }';
}

class NavigateToDisplayName extends SignupEvent {
  @override
  String toString() => 'NavigateToDisplayName event';
}

/// Display Name Events
class NavigateToCreateUsername extends SignupEvent {
  final String displayName;

  const NavigateToCreateUsername(this.displayName);

  @override
  String toString() => 'SaveDisplayName event { displayName: $displayName }';
}

/// Create Username Events
class OnUsernameChange extends SignupEvent {
  final String userName;

  const OnUsernameChange({required this.userName});

  @override
  String toString() => 'OnUsernameChange event { userName: $userName }';
}

class NavigateToAddPhoneNumber extends SignupEvent {
  @override
  String toString() => 'NavigateToAddPhoneNumber event';
}

/// Add Phone Number Events

/// Common Events
class NavigateBack extends SignupEvent {
  @override
  String toString() => 'NavigateBack event';
}
