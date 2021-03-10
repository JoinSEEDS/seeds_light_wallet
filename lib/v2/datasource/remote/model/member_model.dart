class MemberModel {
  final String account;
  final String nickname;
  final String image;

  MemberModel({this.account, this.nickname, this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MemberModel &&
              account == other.account &&
              nickname == other.nickname &&
              image == other.image;

  @override
  int get hashCode => super.hashCode;
}