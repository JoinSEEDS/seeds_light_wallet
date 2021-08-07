import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

class ScoresViewModel extends Equatable {
  final ScoreModel? contributionScore;
  final ScoreModel? communityScore;
  final ScoreModel? reputationScore;
  final PlantedModel? plantedScore;
  final ScoreModel? transactionScore;

  const ScoresViewModel(
      {this.contributionScore, this.communityScore, this.reputationScore, this.plantedScore, this.transactionScore});

  @override
  List<Object?> get props => [contributionScore, communityScore, reputationScore, plantedScore, transactionScore];

  @override
  String toString() =>
      "ScoreViewModel: cs: ${contributionScore?.score} community: ${communityScore?.score} rep: ${reputationScore?.score} planted: ${plantedScore?.quantity} transactions: ${transactionScore?.points}";
}
