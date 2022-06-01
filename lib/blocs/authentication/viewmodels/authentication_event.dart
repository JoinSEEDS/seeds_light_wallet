part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class InitAuthStatus extends AuthenticationEvent {
  const InitAuthStatus();
  @override
  String toString() => 'InitAuthStatus';
}

class InitAuthTimer extends AuthenticationEvent {
  const InitAuthTimer();
  @override
  String toString() => 'InitAuthTimer';
}

class StartTimeoutAuth extends AuthenticationEvent {
  const StartTimeoutAuth();
  @override
  String toString() => 'StartTimeoutAuth';
}

class OnInviteLinkRecived extends AuthenticationEvent {
  const OnInviteLinkRecived();
  @override
  String toString() => 'OnInviteLinkRecived';
}

class OnCreateAccount extends AuthenticationEvent {
  final String account;
  final AuthDataModel authData;
  const OnCreateAccount({required this.account, required this.authData});
  @override
  String toString() => 'OnCreateAccount { account: $account }';
}

class OnImportAccount extends AuthenticationEvent {
  final String account;
  final AuthDataModel authData;
  const OnImportAccount({required this.account, required this.authData});
  @override
  String toString() => 'OnImportAccount { account: $account }';
}

class OnRecoverAccount extends AuthenticationEvent {
  const OnRecoverAccount();
  @override
  String toString() => 'OnRecoverAccount';
}

class OnSwitchAccount extends AuthenticationEvent {
  final String account;
  final AuthDataModel authData;
  const OnSwitchAccount(this.account, this.authData);
  @override
  String toString() => 'OnSwitchAccount { account: $account }';
}

class UnlockWallet extends AuthenticationEvent {
  const UnlockWallet();
  @override
  String toString() => 'UnlockWallet';
}

class EnablePasscode extends AuthenticationEvent {
  final String newPasscode;
  const EnablePasscode({required this.newPasscode});
  @override
  String toString() => 'EnablePasscode';
}

class DisablePasscode extends AuthenticationEvent {
  const DisablePasscode();
  @override
  String toString() => 'DisablePasscode';
}

class EnableBiometric extends AuthenticationEvent {
  const EnableBiometric();
  @override
  String toString() => 'EnableBiometric';
}

class DisableBiometric extends AuthenticationEvent {
  const DisableBiometric();
  @override
  String toString() => 'DisableBiometric';
}

class OnLogout extends AuthenticationEvent {
  const OnLogout();
  @override
  String toString() => 'OnLogout';
}
