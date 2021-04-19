import 'package:equatable/equatable.dart';

class VoiceModelCampaign extends Equatable {
  final int amount;

  const VoiceModelCampaign(this.amount);

  @override
  List<Object> get props => [amount];

  factory VoiceModelCampaign.fromJson(Map<String, dynamic> json) {
    if (json['rows'].isNotEmpty) {
      return VoiceModelCampaign(json['rows'][0]['balance'] as int);
    } else {
      return const VoiceModelCampaign(0);
    }
  }
}
