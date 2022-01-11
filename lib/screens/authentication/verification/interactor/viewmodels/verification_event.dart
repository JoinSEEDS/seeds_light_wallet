part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

class InitBiometricAuth extends VerificationEvent {
  const InitBiometricAuth();
  @override
  String toString() => 'InitBiometricAuth';
}

class OnVerifyPasscode extends VerificationEvent {
  final String passcode;
  const OnVerifyPasscode({required this.passcode});
  @override
  String toString() => 'OnVerifyPasscode';
}

class OnCreatePasscode extends VerificationEvent {
  final String passcode;
  const OnCreatePasscode({required this.passcode});
  @override
  String toString() => 'OnCreatePasscode';
}

class ClearVerificationPageCommand extends VerificationEvent {
  const ClearVerificationPageCommand();
  @override
  String toString() => 'ClearVerificationPageCommand';
}

class PasscodeAuthenticated extends VerificationEvent {
  const PasscodeAuthenticated();
  @override
  String toString() => 'PasscodeAuthenticated';
}
