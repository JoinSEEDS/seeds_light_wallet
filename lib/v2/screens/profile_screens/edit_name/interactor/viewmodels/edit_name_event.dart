import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

/// --- EVENTS
@immutable
abstract class EditNameEvent extends Equatable {
  const EditNameEvent();
  @override
  List<Object?> get props => [];
}

class OnNameChanged extends EditNameEvent {
  final String name;

  const OnNameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'OnNameChanged { name: $name }';
}

class SubmitName extends EditNameEvent {
  final ProfileModel? profile;

  const SubmitName({required this.profile});

  @override
  List<Object?> get props => [profile];

  @override
  String toString() => 'SubmitName { profile: $profile }';
}
