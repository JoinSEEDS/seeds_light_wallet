class VoiceModelCampaign {
  final int amount;

  VoiceModelCampaign(this.amount);

  factory VoiceModelCampaign.fromJson(Map<String, dynamic> json) {
    if (json != null && json["rows"].isNotEmpty) {
      return VoiceModelCampaign(json["rows"][0]["balance"] as int);
    } else {
      return VoiceModelCampaign(0);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VoiceModelCampaign && amount == other.amount;

  @override
  int get hashCode => super.hashCode;
}