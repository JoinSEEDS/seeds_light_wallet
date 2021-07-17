import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

/// --- EVENTS
@immutable
abstract class ContributionEvent extends Equatable {
  const ContributionEvent();
  @override
  List<Object> get props => [];
}

class SetScores extends ContributionEvent {
  final ScoresViewModel? score;
  const SetScores({required this.score});
  @override
  String toString() => 'SetScores { score: $score }';
}
