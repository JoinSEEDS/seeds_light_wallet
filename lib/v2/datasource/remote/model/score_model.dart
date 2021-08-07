import 'package:seeds/v2/utils/string_extension.dart';

class ScoreModel {
  final int points;
  final int score;

  ScoreModel({
    required this.points,
    required this.score,
  });

  double pointsDouble() => points.toDouble();
  double scoreDouble() => score.toDouble();

  factory ScoreModel.fromJson(
      {required Map<String, dynamic> json, required String pointsName, String rankName = "rank"}) {
    if (json['rows'].isNotEmpty) {
      Map<String, dynamic> item = json['rows'][0];
      return ScoreModel(
        points: item[pointsName],
        score: item[rankName],
      );
    } else {
      return ScoreModel(
        points: 0,
        score: 0,
      );
    }
  }

  factory ScoreModel.fromJsonPlanted(
      {required Map<String, dynamic> json, required String pointsName, String rankName = "rank"}) {
    if (json['rows'].isNotEmpty) {
      Map<String, dynamic> item = json['rows'][0];
      String assetString = item[pointsName];
      int assetAsInt = assetString.assetAmount as int;
      return ScoreModel(
        points: assetAsInt,
        score: item[rankName],
      );
    } else {
      return ScoreModel(
        points: 0,
        score: 0,
      );
    }
  }

  @override
  String toString() {
    return "ScoreModel: points: $points score: $score";
  }
}
