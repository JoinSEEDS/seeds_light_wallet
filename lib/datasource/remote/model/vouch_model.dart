import 'package:equatable/equatable.dart';

class VouchModel extends Equatable {
  final String sponsor;
  final String account;
  final int vouchPoints;

  const VouchModel({
    required this.sponsor,
    required this.account,
    required this.vouchPoints,
  });

  factory VouchModel.fromJson(Map<String, dynamic> json) {
    return VouchModel(
      sponsor: json['sponsor'],
      account: json['account'],
      vouchPoints: json['vouch_points'],
    );
  }

  @override
  List<Object?> get props => [sponsor, account, vouchPoints];
}
