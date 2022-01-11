part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class OnInviteCodeFromDeepLink extends SignupEvent {
  final String? inviteCode;

  const OnInviteCodeFromDeepLink(this.inviteCode);

  @override
  String toString() => 'OnInviteCodeFromDeepLink { inviteCode: $inviteCode }';
}

class OnQRScanned extends SignupEvent {
  final String scannedLink;

  const OnQRScanned(this.scannedLink);

  @override
  String toString() => 'OnQRScanned { scannedLink: $scannedLink }';
}

class ClearSignupPageCommand extends SignupEvent {
  const ClearSignupPageCommand();

  @override
  String toString() => 'ClearSignupPageCommand';
}

class OnInvalidInviteDialogClosed extends SignupEvent {
  @override
  String toString() => 'OnInvalidInviteDialogClosed';
}

class DisplayNameOnNextTapped extends SignupEvent {
  final String displayName;

  const DisplayNameOnNextTapped(this.displayName);

  @override
  String toString() => 'DisplayNameOnNextTapped { displayName: $displayName }';
}

class OnGenerateNewUsername extends SignupEvent {
  final String fullname;

  const OnGenerateNewUsername(this.fullname);

  @override
  String toString() => 'GenerateNewUsername { fullname: $fullname }';
}

class OnAccountNameChanged extends SignupEvent {
  final String accountName;

  const OnAccountNameChanged(this.accountName);

  @override
  String toString() => 'OnAccountNameChanged { accountName: $accountName }';
}

class OnCreateAccountTapped extends SignupEvent {
  const OnCreateAccountTapped(this.phoneNumber);

  final String? phoneNumber;

  @override
  String toString() => 'OnCreateAccountTapped { phoneNumber: $phoneNumber }';
}

class OnBackPressed extends SignupEvent {
  const OnBackPressed();

  @override
  String toString() => 'OnBackPressed';
}
