part of 'contribution_bloc.dart';

abstract class ContributionEvent extends Equatable {
  const ContributionEvent();

  @override
  List<Object?> get props => [];
}

class SetScores extends ContributionEvent {
  final ScoresViewModel? score;

  const SetScores({required this.score});

  @override
  String toString() => 'SetScores { score: $score }';
}

class FetchScores extends ContributionEvent {
  const FetchScores();

  @override
  String toString() => 'FetchScores';
}

class ShowScoreDetails extends ContributionEvent {
  final ScoreType scoreType;

  const ShowScoreDetails(this.scoreType);

  @override
  String toString() => 'ShowScoreDetails {scoreType: $scoreType}';
}

class ClearContributionPageCommand extends ContributionEvent {
  const ClearContributionPageCommand();

  @override
  String toString() => 'ClearContributionPageCommand';
}
