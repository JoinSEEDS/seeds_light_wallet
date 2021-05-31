import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';

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
  String toString() => 'InitGuardians: { InitGuardians: $myGuardians }';
}

class OnAddGuardiansTapped extends GuardiansEvent {
  @override
  String toString() => 'OnAddGuardiansTapped ';
}

class OnAcceptGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  OnAcceptGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnAcceptGuardianTapped : { OnAcceptGuardianTapped: $guardianAccount }';
}

class OnDeclineGuardianTapped extends GuardiansEvent {
  final String guardianAccount;

  OnDeclineGuardianTapped(this.guardianAccount);

  @override
  String toString() => 'OnDeclineGuardianTapped : { OnDeclineGuardianTapped: $guardianAccount }';
}

class OnCancelGuardianRequestTapped extends GuardiansEvent {
  final String guardianAccount;

  OnCancelGuardianRequestTapped(this.guardianAccount);

  @override
  String toString() => 'OnCancelGuardianRequestTapped : { OnCancelGuardianRequestTapped: $guardianAccount }';
}
