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
  const OnVerifyPasscode(this.passcode);
  @override
  String toString() => 'OnVerifyPasscode';
}

class OnPasscodeCreated extends VerificationEvent {
  final String passcode;
  const OnPasscodeCreated(this.passcode);
  @override
  String toString() => 'OnPasscodeCreated';
}

class ClearVerificationPageCommand extends VerificationEvent {
  const ClearVerificationPageCommand();
  @override
  String toString() => 'ClearVerificationPageCommand';
}
