import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final String account;
  final String nickname;
  final String image;
  final bool isSeedsUser;

  const MemberModel({required this.account, required this.nickname, required this.image, this.isSeedsUser = true});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
    );
  }

  factory MemberModel.fromTelosAccount(String account) {
    return MemberModel(
      account: account,
      nickname: "",
      image: "assets/images/send/telos_logo.png",
      isSeedsUser: false,
    );
  }

  @override
  List<Object?> get props => [account, nickname, image];
}
