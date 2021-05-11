import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';

/// --- EVENTS
@immutable
abstract class GuardiansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadGuardians extends GuardiansEvent {
  final String userName;

  LoadGuardians({required this.userName});

  @override
  String toString() => 'LoadGuardians: { userName: $userName }';
}

class InitGuardians extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;
  
  InitGuardians(this.myGuardians);

  @override
  String toString() => 'InitGuardians: { InitGuardians: $myGuardians }';
  
}