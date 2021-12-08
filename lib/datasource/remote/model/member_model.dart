import 'package:flutter/foundation.dart';
import 'package:seeds/datasource/remote/model/serialization_helpers.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';

class MemberModel {
  final String account;
  final String nickname;
  final String image;
  final String status;
  final bool isSeedsUser;

  const MemberModel({
    required this.account,
    required this.nickname,
    required this.image,
    required this.status,
    this.isSeedsUser = true,
  });

  UserCitizenshipStatus get userCitizenshipStatus {
    return enumFromString<UserCitizenshipStatus>(UserCitizenshipStatus.values, status);
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
      status: json['status'] ?? '',
    );
  }

  factory MemberModel.fromTelosAccount(String account) {
    return MemberModel(
      account: account,
      nickname: "",
      image: "assets/images/send/telos_logo.png",
      status: describeEnum(UserCitizenshipStatus.unknown),
      isSeedsUser: false,
    );
  }
}
