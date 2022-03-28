import 'package:equatable/equatable.dart';

class RegionMemberModel extends Equatable {
  final String region;
  final String account;
  final String joinedDate;

  const RegionMemberModel({
    required this.region,
    required this.account,
    required this.joinedDate,
  });

  factory RegionMemberModel.fromJson(Map<String, dynamic> json) {
    return RegionMemberModel(
      region: json['region'],
      account: json['account'],
      joinedDate: json['joined_date'],
    );
  }

  @override
  List<Object?> get props => [region, account, joinedDate];
}
