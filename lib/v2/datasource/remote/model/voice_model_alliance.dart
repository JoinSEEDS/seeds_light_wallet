class VoiceModelAlliance {
  final int? amount;

  VoiceModelAlliance(this.amount);

  factory VoiceModelAlliance.fromJson(Map<String, dynamic> json) {
    if (json != null && json['rows'].isNotEmpty) {
      return VoiceModelAlliance(json['rows'][0]['balance'] as int?);
    } else {
      return VoiceModelAlliance(0);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is VoiceModelAlliance && amount == other.amount;

  @override
  int get hashCode => super.hashCode;
}
