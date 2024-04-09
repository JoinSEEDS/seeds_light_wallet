class SeedsSettingsModel {
  final String param;
  final int value;
  final String description;
  final String impact;

  const SeedsSettingsModel({
    required this.param,
    required this.value,
    required this.description,
    required this.impact,
  });

  factory SeedsSettingsModel.fromJson(Map<String, dynamic> json) {
    return SeedsSettingsModel(
      param: json['param'] as String,
      value: json['value'] as int,
      description: json['description'] as String,
      impact: json['impact'] as String,
    );
  }
}
