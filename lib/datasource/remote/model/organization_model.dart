class OrganizationModel {
  final String orgName;
  final String owner;
  final int status;
  final int regen;
  final int reputation;
  final int voice;
  final String planted;

  const OrganizationModel({
    required this.orgName,
    required this.owner,
    required this.status,
    required this.regen,
    required this.reputation,
    required this.voice,
    required this.planted,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      orgName: json['org_name'] as String,
      owner: json['owner'] as String,
      status: json['status'] as int,
      regen: json['regen'] as int,
      reputation: json['reputation'] as int,
      voice: json['voice'] as int,
      planted: json['planted'] as String,
    );
  }
}
