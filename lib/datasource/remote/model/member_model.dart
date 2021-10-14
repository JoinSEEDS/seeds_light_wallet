import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/serialization_helpers.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';

class MemberModel extends Equatable {
  final String account;
  final String nickname;
  final String image;
  final bool isSeedsUser;
  final UserCitizenshipStatus? citizenshipStatus;

  const MemberModel({
    required this.account,
    required this.nickname,
    required this.image,
    this.isSeedsUser = true,
    this.citizenshipStatus,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
      citizenshipStatus: enumFromString<UserCitizenshipStatus>(
          UserCitizenshipStatus.values, hasEmptyValue<String>('status', json)),
    );
  }

  factory MemberModel.fromTelosAccount(String account) {
    return MemberModel(
      account: account,
      nickname: "",
      image: "assets/images/send/telos_logo.png",
      isSeedsUser: false,
      citizenshipStatus: UserCitizenshipStatus.unknown,
    );
  }

  @override
  List<Object?> get props => [account, nickname, image, citizenshipStatus];
}
