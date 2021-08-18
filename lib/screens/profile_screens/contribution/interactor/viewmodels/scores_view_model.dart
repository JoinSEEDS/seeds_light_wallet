import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';

class ScoresViewModel extends Equatable {
  final ScoreModel? contributionScore;
  final ScoreModel? communityScore;
  final ScoreModel? reputationScore;
  final ScoreModel? plantedScore;
  final ScoreModel? transactionScore;

  const ScoresViewModel(
      {this.contributionScore, this.communityScore, this.reputationScore, this.plantedScore, this.transactionScore});

  @override
  List<Object?> get props => [contributionScore, communityScore, reputationScore, plantedScore, transactionScore];

  @override
  String toString() =>
      "ScoreViewModel: cs: ${contributionScore?.value} community: ${communityScore?.value} rep: ${reputationScore?.value} planted: ${plantedScore?.value} transactions: ${transactionScore?.value}";
}
