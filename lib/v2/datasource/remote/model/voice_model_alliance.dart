import 'package:equatable/equatable.dart';

class VoiceModelAlliance extends Equatable {
  final int amount;

  const VoiceModelAlliance(this.amount);

  @override
  List<Object> get props => [amount];

  factory VoiceModelAlliance.fromJson(Map<String, dynamic> json) {
    if (json['rows'].isNotEmpty) {
      return VoiceModelAlliance(json['rows'][0]['balance'] as int);
    } else {
      return const VoiceModelAlliance(0);
    }
  }
}
