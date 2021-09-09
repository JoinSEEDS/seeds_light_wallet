class QuorumLevelModel {
  final String param;
  final int value;
  final String description;
  final String impact;

  const QuorumLevelModel({
    required this.param,
    required this.value,
    required this.description,
    required this.impact,
  });

  factory QuorumLevelModel.fromJson(Map<String, dynamic> json) {
    return QuorumLevelModel(
      param: json['param'],
      value: json['value'],
      description: json['description'],
      impact: json['impact'],
    );
  }
}
