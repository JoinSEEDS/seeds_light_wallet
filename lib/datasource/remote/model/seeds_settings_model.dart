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
      param: json['param'],
      value: json['value'],
      description: json['description'],
      impact: json['impact'],
    );
  }
}
