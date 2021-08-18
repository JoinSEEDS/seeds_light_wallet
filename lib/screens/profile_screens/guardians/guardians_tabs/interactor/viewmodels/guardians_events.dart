import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

/// --- EVENTS
@immutable
abstract class GuardiansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitGuardians extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  InitGuardians(this.myGuardians);

  @override
  String toString() => 'InitGuardians: { myGuardians: $myGuardians }';
}

class OnAddGuardiansTapped extends GuardiansEvent {
  @override
  String toString() => 'OnAddGuardiansTapped';
}

class OnAcceptGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  OnAcceptGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnAcceptGuardianTapped : { guardianAccount: $guardianAccount }';
}

class OnDeclineGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  OnDeclineGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnDeclineGuardianTapped : { guardianAccount: $guardianAccount }';
}

class OnCancelGuardianRequestTapped extends GuardiansEvent {
  final String guardianAccount;

  OnCancelGuardianRequestTapped(this.guardianAccount);

  @override
  String toString() => 'OnCancelGuardianRequestTapped : { guardianAccount: $guardianAccount }';
}

class OnGuardianRowTapped extends GuardiansEvent {
  final GuardianModel guardian;

  OnGuardianRowTapped(this.guardian);

  @override
  String toString() => 'OnGuardianRowTapped : { guardian: $guardian }';
}

class ClearPageCommand extends GuardiansEvent {
  @override
  String toString() => 'ClearPageCommand';
}

class OnStopRecoveryForUser extends GuardiansEvent {
  @override
  String toString() => 'OnStopRecoveryForUser';
}

class OnRemoveGuardianTapped extends GuardiansEvent {
  final GuardianModel guardian;

  OnRemoveGuardianTapped(this.guardian);

  @override
  String toString() => 'OnRemoveGuardianTapped : { guardian: $guardian }';
}

class InitOnboardingGuardian extends GuardiansEvent {
  @override
  String toString() => 'InitOnboardingGuardian';
}

class OnNextGuardianOnboardingTapped extends GuardiansEvent {
  @override
  String toString() => 'OnNextGuardianOnboardingTapped';
}

class OnPreviousGuardianOnboardingTapped extends GuardiansEvent {
  @override
  String toString() => 'OnPreviousGuardianOnboardingTapped';
}

class OnGuardianReadyForActivation extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  OnGuardianReadyForActivation(this.myGuardians);

  @override
  String toString() => 'OnGuardianReadyForActivation: { myGuardians: $myGuardians }';
}
