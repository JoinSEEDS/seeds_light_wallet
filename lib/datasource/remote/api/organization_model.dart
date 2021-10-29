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
      orgName: json['org_name'],
      owner: json['owner'],
      status: json['status'],
      regen: json['regen'],
      reputation: json['reputation'],
      voice: json['voice'],
      planted: json['planted'],
    );
  }
}
