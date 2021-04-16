import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

/// --- EVENTS
@immutable
abstract class ContributionEvent extends Equatable {
  const ContributionEvent();
  @override
  List<Object> get props => [];
}

class SetScores extends ContributionEvent {
  final ScoreModel? score;
  const SetScores({required this.score});
  @override
  String toString() => 'SetScores { score: $score }';
}
