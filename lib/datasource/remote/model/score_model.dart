class ScoreModel {
  final int value;

  ScoreModel({
    required this.value,
  });

  double toDouble() => value.toDouble();

  factory ScoreModel.fromJson({required Map<String, dynamic> json, String fieldName = "rank"}) {
    if (json['rows'].isNotEmpty) {
      final Map<String, dynamic> item = json['rows'][0];
      return ScoreModel(
        value: item[fieldName],
      );
    } else {
      return ScoreModel(
        value: 0,
      );
    }
  }

  @override
  String toString() {
    return "ScoreModel: $value";
  }
}
