class ProfileModel {
  final String? account;
  final String? status;
  final String? type;
  final String? nickname;
  final String? image;
  final String? story;
  final String? roles;
  final String? skills;
  final String? interests;
  final int? reputation;
  final int? timestamp;

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

  /// Returns the account age in days
  int get accountAge {
    var creationDate = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return DateTime.now().difference(creationDate).inDays;
  }

  ProfileModel copyWith({
    String? account,
    String? status,
    String? type,
    String? nickname,
    String? image,
    String? story,
    String? roles,
    String? skills,
    String? interests,
    int? reputation,
    int? timestamp,
  }) {
    return ProfileModel(
      account: account ?? this.account,
      status: status ?? this.status,
      type: type ?? this.type,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      story: story ?? this.story,
      roles: roles ?? this.roles,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      reputation: reputation ?? this.reputation,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      account: json['account'],
      status: json['status'],
      type: json['type'],
      nickname: json['nickname'],
      image: json['image'],
      story: json['story'],
      roles: json['roles'],
      skills: json['skills'],
      interests: json['interests'],
      reputation: json['reputation'],
      timestamp: json['timestamp'],
    );
  }
}
