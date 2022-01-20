import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';

enum ScoreType { contributionScore, communityScore, reputationScore, plantedScore, transactionScore }

extension ScoreTypeExtension on ScoreType {
  String get value {
    switch (this) {
      case ScoreType.contributionScore:
        return 'Contribution';
      case ScoreType.communityScore:
        return 'Community';
      case ScoreType.reputationScore:
        return 'Reputation';
      case ScoreType.plantedScore:
        return 'Planted Seeds';
      case ScoreType.transactionScore:
        return 'Transaction';
    }
  }
}

class ScoresViewModel extends Equatable {
  final ScoreModel? contributionScore;
  final ScoreModel? communityScore;
  final ScoreModel? reputationScore;
  final ScoreModel? plantedScore;
  final ScoreModel? transactionScore;

  const ScoresViewModel({
    this.contributionScore,
    this.communityScore,
    this.reputationScore,
    this.plantedScore,
    this.transactionScore,
  });

  @override
  List<Object?> get props => [
        contributionScore,
        communityScore,
        reputationScore,
        plantedScore,
        transactionScore,
      ];

  @override
  String toString() =>
      "ScoreViewModel: cs: ${contributionScore?.value} community: ${communityScore?.value} rep: ${reputationScore?.value} planted: ${plantedScore?.value} transactions: ${transactionScore?.value}";
}
