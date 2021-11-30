import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

/// --- EVENTS
@immutable
abstract class CitizenshipEvent extends Equatable {
  const CitizenshipEvent();

  @override
  List<Object> get props => [];
}

class SetValues extends CitizenshipEvent {
  final ProfileModel? profile;

  const SetValues({required this.profile});

  @override
  String toString() => 'SetValues { profile: $profile }';
}
