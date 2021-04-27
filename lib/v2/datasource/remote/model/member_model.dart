import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final String account;
  final String? nickname;
  final String? image;

  const MemberModel({required this.account, this.nickname, this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json['account'],
      nickname: json['nickname'],
      image: json['image'],
    );
  }

  @override
  List<Object?> get props => [account, nickname, image];
}
