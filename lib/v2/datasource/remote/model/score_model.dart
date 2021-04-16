class ScoreModel {
  final int? plantedScore;
  final int? transactionsScore;
  final int? reputationScore;
  final int? communityBuildingScore;
  final int? contributionScore;

  ScoreModel({
    this.plantedScore,
    this.transactionsScore,
    this.reputationScore,
    this.communityBuildingScore,
    this.contributionScore,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'].isNotEmpty) {
      Map<String, dynamic> item = json['rows'][0];
      return ScoreModel(
        plantedScore: item['planted_score'],
        transactionsScore: item['transactions_score'],
        reputationScore: item['reputation_score'],
        communityBuildingScore: item['community_building_score'],
        contributionScore: item['contribution_score'],
      );
    } else {
      return ScoreModel(
        plantedScore: 0,
        transactionsScore: 0,
        reputationScore: 0,
        communityBuildingScore: 0,
        contributionScore: 0,
      );
    }
  }
}
