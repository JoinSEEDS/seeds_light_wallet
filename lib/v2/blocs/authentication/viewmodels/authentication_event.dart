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

class InitAuthentication extends AuthenticationEvent {
  const InitAuthentication();
  @override
  String toString() => 'InitAuthentication';
}

class TryAgainBiometric extends AuthenticationEvent {
  const TryAgainBiometric();
  @override
  String toString() => 'TryAgainBiometric';
}

class SetPasscodeAsPrefered extends AuthenticationEvent {
  const SetPasscodeAsPrefered();
  @override
  String toString() => 'SetPasscodeAsPrefered';
}

class ResetPasscode extends AuthenticationEvent {
  const ResetPasscode();
  @override
  String toString() => 'ResetPasscode';
}

class DisablePasscode extends AuthenticationEvent {
  const DisablePasscode();
  @override
  String toString() => 'DisablePasscode';
}

class PasscodeAuthenticated extends AuthenticationEvent {
  const PasscodeAuthenticated();
  @override
  String toString() => 'PasscodeAuthenticated';
}
