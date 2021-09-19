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
      id: json["referendum_id"],
      createdAt: json["created_at"],
      settingValue: json["setting_value"],
      settingName: json["setting_name"],
      total: json["favour"] + json["against"],
      favour: json["favour"],
      against: json["against"],
      creator: json["creator"],
      staked: json["staked"],
      title: json["title"],
      summary: json["summary"],
      description: json["description"],
      image: json["image"],
      url: json["url"],
      scope: scope == 'failed' ? 'rejected' : scope,
    );
  }
}
