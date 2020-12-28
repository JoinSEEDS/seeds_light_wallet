abstract class OnboardingEvent {
  String loaderNotion;
}

class FoundInviteLink extends OnboardingEvent {
  String inviteMnemonic;
}

class FoundNoLink extends OnboardingEvent {}

class FoundInviteDetails extends OnboardingEvent {
  String inviterAccount;
  String inviteCode;
}

class FoundNoInvite extends OnboardingEvent {}

class InviteAccepted extends OnboardingEvent {}

class InviteRejected extends OnboardingEvent {}

class CreateAccountNameEntered extends OnboardingEvent {
  String nickname;
}

class CreateAccountAccountNameBack extends OnboardingEvent {}

class CreateAccountRequestedFinal extends OnboardingEvent {
  String accountName;
  String nickname;
}

class ClaimInviteRequested extends OnboardingEvent {
  String inviteSecret;
  String inviterAccount;
}

class ChosenImportAccount extends OnboardingEvent {}

class ChosenClaimInvite extends OnboardingEvent {}

class ChosenRecoverAccount extends OnboardingEvent {}

class ImportAccountRequested extends OnboardingEvent {
  String accountName;
  String privateKey;
}

class AccountImported extends OnboardingEvent {}

class ImportAccountFailed extends OnboardingEvent {}

class AccountCreated extends OnboardingEvent {
  String privateKey;
}

class CreateAccountFailed extends OnboardingEvent {}

class ContinueRecoveryCanceled extends OnboardingEvent {}

class StartRecoveryRequested extends OnboardingEvent {
  String accountName;
}

class ClaimRecoveredAccount extends OnboardingEvent {}

class ClaimFailed extends OnboardingEvent {}

class FoundRecoveryFlag extends OnboardingEvent {
  String accountName;
  String privateKey;
}

class OnboardingInit extends OnboardingEvent {}

class BackPressed extends OnboardingEvent {}