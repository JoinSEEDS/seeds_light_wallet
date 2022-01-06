part of 'citizenship_bloc.dart';

abstract class CitizenshipEvent extends Equatable {
  const CitizenshipEvent();

  @override
  List<Object?> get props => [];
}

class SetValues extends CitizenshipEvent {
  final ProfileModel? profile;

  const SetValues({required this.profile});

  @override
  String toString() => 'SetValues { profile: $profile }';
}
