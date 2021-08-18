import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

/// --- EVENTS
@immutable
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object> get props => [];
}

class SetUpInitialValues extends SecurityEvent {
  const SetUpInitialValues();
  @override
  String toString() => 'SetUpInitialValues';
}

class ShouldShowNotificationBadge extends SecurityEvent {
  final bool value;
  const ShouldShowNotificationBadge({required this.value});
  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class OnLoadingGuardians extends SecurityEvent {
  final List<GuardianModel> guardians;

  const OnLoadingGuardians({required this.guardians});
  @override
  String toString() => 'OnLoadingGuardians { guardians: $guardians }';
}

class OnGuardiansCardTapped extends SecurityEvent {
  const OnGuardiansCardTapped();
  @override
  String toString() => 'OnGuardiansCardTapped';
}

class OnPasscodePressed extends SecurityEvent {
  const OnPasscodePressed();
  @override
  String toString() => 'OnPasscodePressed';
}

class OnBiometricPressed extends SecurityEvent {
  const OnBiometricPressed();
  @override
  String toString() => 'OnBiometricPressed';
}

class ResetNavigateToVerification extends SecurityEvent {
  const ResetNavigateToVerification();
  @override
  String toString() => 'ResetNavigateToVerification';
}

class OnValidVerification extends SecurityEvent {
  const OnValidVerification();
  @override
  String toString() => 'OnValidVerification';
}
