class ReferendumModel {
  final int id;
  final int createdAt;
  final int settingValue;
  final int total;
  final int favour;
  final int against;
  final String settingName;
  final String creator;
  final String staked;
  final String title;
  final String summary;
  final String description;
  final String image;
  final String url;
  // The scope its jus to handle UI status label
  final String scope;

  const ReferendumModel(
      {required this.id,
      required this.createdAt,
      required this.settingValue,
      required this.total,
      required this.favour,
      required this.against,
      required this.settingName,
      required this.creator,
      required this.staked,
      required this.title,
      required this.summary,
      required this.description,
      required this.image,
      required this.url,
      required this.scope});

  factory ReferendumModel.fromJson(Map<String, dynamic> json, String scope) {
    return ReferendumModel(
      id: json["referendum_id"] as int,
      createdAt: json["created_at"] as int,
      settingValue: json["setting_value"] as int,
      settingName: json["setting_name"] as String,
      total: (json["favour"] as int) + (json["against"] as int),
      favour: json["favour"] as int,
      against: json["against"] as int,
      creator: json["creator"] as String,
      staked: json["staked"] as String,
      title: json["title"] as String,
      summary: json["summary"] as String,
      description: json["description"] as String,
      image: json["image"] as String,
      url: json["url"] as String,
      scope: scope == 'failed' ? 'rejected' : scope,
    );
  }
}
