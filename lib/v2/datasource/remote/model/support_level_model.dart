class SupportLevelModel {
  final int propcycle;
  final int numProposals;
  final int totaVoiceCast;
  final int voiceNeeded;

  SupportLevelModel({
    required this.propcycle,
    required this.numProposals,
    required this.totaVoiceCast,
    required this.voiceNeeded,
  });

  factory SupportLevelModel.fromJson(Map<String, dynamic> json) {
    return SupportLevelModel(
      propcycle: json['propcycle'],
      numProposals: json['num_proposals'],
      totaVoiceCast: json['total_voice_cast'],
      voiceNeeded: json['voice_needed'],
    );
  }
}
