class VoiceModel {
  final int amount;

  VoiceModel(this.amount);

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    return VoiceModel(json[0] as int);
  }
}
