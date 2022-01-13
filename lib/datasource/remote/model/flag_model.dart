import 'package:equatable/equatable.dart';

class FlagModel extends Equatable {
  final int id;
  final String from;
  final String to;
  final int flagPoints;

  const FlagModel({
    required this.id,
    required this.from,
    required this.to,
    required this.flagPoints,
  });

  factory FlagModel.fromJson(Map<String, dynamic> json) {
    return FlagModel(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      flagPoints: json['flag_points'],
    );
  }

  @override
  List<Object?> get props => [id, from, to, flagPoints];
}
