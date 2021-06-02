part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

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

class NavigateToDisplayName extends SignupEvent {}

class NavigateToCreateUsername extends SignupEvent {
  final String displayName;

  const NavigateToCreateUsername(this.displayName);

  @override
  String toString() => 'SaveDisplayName event { displayName: $displayName }';
}

class NavigateBack extends SignupEvent {}
