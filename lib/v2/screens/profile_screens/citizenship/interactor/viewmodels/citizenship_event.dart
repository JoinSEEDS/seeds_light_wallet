import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

/// --- EVENTS
@immutable
abstract class CitizenshipEvent extends Equatable {
  const CitizenshipEvent();
  @override
  List<Object> get props => [];
}

class SetValues extends CitizenshipEvent {
  final ProfileModel? profile;
  final ScoresViewModel? score;
  const SetValues({required this.profile, required this.score});
  @override
  String toString() => 'SetValues { profile: $profile score: $score }';
}
