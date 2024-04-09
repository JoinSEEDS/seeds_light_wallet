class SupportLevelModel {
  final int propcycle;
  final int numProposals;
  final int totaVoiceCast;
  final int voiceNeeded;

  const SupportLevelModel({
    required this.propcycle,
    required this.numProposals,
    required this.totaVoiceCast,
    required this.voiceNeeded,
  });

  factory SupportLevelModel.fromJson(Map<String, dynamic> json) {
    return SupportLevelModel(
      propcycle: json['propcycle'] as int,
      numProposals: json['num_proposals'] as int,
      totaVoiceCast: json['total_voice_cast']as int,
      voiceNeeded: json['voice_needed'] as int,
    );
  }
}
