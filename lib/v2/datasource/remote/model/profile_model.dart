class ProfileModel {
  final String account;
  final String status;
  final String type;
  final String nickname;
  final String image;
  final String story;
  final String roles;
  final String skills;
  final String interests;
  final int reputation;
  final int timestamp;

  ProfileModel({
    this.account,
    this.status,
    this.type,
    this.nickname,
    this.image,
    this.story,
    this.roles,
    this.skills,
    this.interests,
    this.reputation,
    this.timestamp,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      account: json["account"],
      status: json["status"],
      type: json["type"],
      nickname: json["nickname"],
      image: json["image"],
      story: json["story"],
      roles: json["roles"],
      skills: json["skills"],
      interests: json["interests"],
      reputation: json["reputation"],
      timestamp: json["timestamp"],
    );
  }
}