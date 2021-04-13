import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class VerificationEvent extends Equatable {
  const VerificationEvent();
  @override
  List<Object> get props => [];
}

class InitVerification extends VerificationEvent {
  const InitVerification();
  @override
  String toString() => 'InitVerification';
}

class OnVerifyPasscode extends VerificationEvent {
  final String passcode;
  const OnVerifyPasscode({required this.passcode}) : assert(passcode != null);
  @override
  String toString() => 'OnVerifyPasscode { passcode: $passcode }';
}

class OnValidVerifyPasscode extends VerificationEvent {
  const OnValidVerifyPasscode();
  @override
  String toString() => 'OnValidVerifyPasscode';
}

class OnCreatePasscode extends VerificationEvent {
  final String passcode;
  const OnCreatePasscode({required this.passcode}) : assert(passcode != null);
  @override
  String toString() => 'OnCreatePasscode { passcode: $passcode }';
}

class ResetShowSnack extends VerificationEvent {
  const ResetShowSnack();
  @override
  String toString() => 'ResetShowSnack';
}

class TryAgainBiometric extends VerificationEvent {
  const TryAgainBiometric();
  @override
  String toString() => 'TryAgainBiometric';
}

class PasscodeAuthenticated extends VerificationEvent {
  const PasscodeAuthenticated();
  @override
  String toString() => 'PasscodeAuthenticated';
}
