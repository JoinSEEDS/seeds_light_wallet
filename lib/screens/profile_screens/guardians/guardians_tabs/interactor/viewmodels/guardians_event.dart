part of 'guardians_bloc.dart';

abstract class GuardiansEvent extends Equatable {
  const GuardiansEvent();

  @override
  List<Object?> get props => [];
}

class InitGuardians extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  const InitGuardians(this.myGuardians);

  @override
  String toString() => 'InitGuardians: { myGuardians: $myGuardians }';
}

class OnAddGuardiansTapped extends GuardiansEvent {
  @override
  String toString() => 'OnAddGuardiansTapped';
}

class OnAcceptGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  const OnAcceptGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnAcceptGuardianTapped : { guardianAccount: $guardianAccount }';
}

class OnDeclineGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  const OnDeclineGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnDeclineGuardianTapped : { guardianAccount: $guardianAccount }';
}

class OnCancelGuardianRequestTapped extends GuardiansEvent {
  final String guardianAccount;

  const OnCancelGuardianRequestTapped(this.guardianAccount);

  @override
  String toString() => 'OnCancelGuardianRequestTapped : { guardianAccount: $guardianAccount }';
}

class OnGuardianRowTapped extends GuardiansEvent {
  final GuardianModel guardian;

  const OnGuardianRowTapped(this.guardian);

  @override
  String toString() => 'OnGuardianRowTapped : { guardian: $guardian }';
}

class ClearPageCommand extends GuardiansEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}

class OnStopRecoveryForUser extends GuardiansEvent {
  @override
  String toString() => 'OnStopRecoveryForUser';
}

class OnRemoveGuardianTapped extends GuardiansEvent {
  final GuardianModel guardian;

  const OnRemoveGuardianTapped(this.guardian);

  @override
  String toString() => 'OnRemoveGuardianTapped : { guardian: $guardian }';
}

class InitOnboardingGuardian extends GuardiansEvent {
  const InitOnboardingGuardian();

  @override
  String toString() => 'InitOnboardingGuardian';
}

class OnNextGuardianOnboardingTapped extends GuardiansEvent {
  const OnNextGuardianOnboardingTapped();

  @override
  String toString() => 'OnNextGuardianOnboardingTapped';
}

class OnPreviousGuardianOnboardingTapped extends GuardiansEvent {
  const OnPreviousGuardianOnboardingTapped();

  @override
  String toString() => 'OnPreviousGuardianOnboardingTapped';
}

class OnGuardianReadyForActivation extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  const OnGuardianReadyForActivation(this.myGuardians);

  @override
  String toString() => 'OnGuardianReadyForActivation: { myGuardians: $myGuardians }';
}
