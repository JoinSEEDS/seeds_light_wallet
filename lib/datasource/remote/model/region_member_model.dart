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
      region: json['region'] as String,
      account: json['account'] as String,
      joinedDate: json['joined_date'] as String,
    );
  }

  @override
  List<Object?> get props => [region, account, joinedDate];
}
