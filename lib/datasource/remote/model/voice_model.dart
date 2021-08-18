class VoiceModel {
  final int amount;

  const VoiceModel(this.amount);

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'].isNotEmpty) {
      return VoiceModel(json['rows'][0]['balance'] as int);
    } else {
      return const VoiceModel(0);
    }
  }
}
