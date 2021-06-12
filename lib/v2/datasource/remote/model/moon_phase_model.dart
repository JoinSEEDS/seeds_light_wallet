class MoonPhasesList {
  final List<MoonPhase> moonPhases;

  MoonPhasesList(this.moonPhases);

  factory MoonPhasesList.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      return MoonPhasesList(json['rows'].map<MoonPhase>((i) => MoonPhase.fromJson(i)).toList());
    } else {
      return MoonPhasesList([]);
    }
  }
}

class MoonPhase {
  final int timestamp;
  final String time;
  final String phaseName;
  final String eclipse;

  MoonPhase({
    required this.timestamp,
    required this.time,
    required this.phaseName,
    required this.eclipse,
  });

  factory MoonPhase.fromJson(Map<String, dynamic> json) {
    return MoonPhase(
      timestamp: json['timestamp'],
      time: json['time'],
      phaseName: json['phase_name'],
      eclipse: json['eclipse'],
    );
  }
}
