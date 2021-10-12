import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/serialization_helpers.dart';
import 'package:seeds/domain-shared/profile_citizenship_status.dart';

class MemberModel extends Equatable {
  final String account;
  final String nickname;
  final String image;
  final bool isSeedsUser;
  final ProfileCitizenshipStatus? status;

  const MemberModel(
      {required this.account, required this.nickname, required this.image, this.isSeedsUser = true, this.status});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
      status: enumFromString<ProfileCitizenshipStatus>(
          ProfileCitizenshipStatus.values, hasEmptyValue<String>('status', json)),
    );
  }

  factory MemberModel.fromTelosAccount(String account) {
    return MemberModel(
      account: account,
      nickname: "",
      image: "assets/images/send/telos_logo.png",
      isSeedsUser: false,
      status: ProfileCitizenshipStatus.unknown,
    );
  }

  @override
  List<Object?> get props => [account, nickname, image, status];
}
