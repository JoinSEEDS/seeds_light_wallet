import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class InitAuthStatus extends AuthenticationEvent {
  const InitAuthStatus();
  @override
  String toString() => 'InitAuthStatus';
}

class OnImportAccount extends AuthenticationEvent {
  final String account;
  final String privateKey;
  const OnImportAccount({required this.account, required this.privateKey});
  @override
  String toString() => 'OnImportAccount { account: $account }';
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
  String toString() => 'EnablePasscode { newPasscode: $newPasscode }';
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
