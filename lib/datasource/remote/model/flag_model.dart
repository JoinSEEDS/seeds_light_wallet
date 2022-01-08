import 'package:equatable/equatable.dart';

class FlagModel extends Equatable {
  final String account;
  final int flagPoints;

  const FlagModel({
    required this.account,
    required this.flagPoints,
  });

  factory FlagModel.fromJson(Map<String, dynamic> json) {
    return FlagModel(
      account: json['account'],
      flagPoints: json['flag_points'],
    );
  }

  @override
  List<Object?> get props => [account, flagPoints];
}
