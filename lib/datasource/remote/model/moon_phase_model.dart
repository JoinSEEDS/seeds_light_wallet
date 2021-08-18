class MoonPhaseModel {
  final int timestamp;
  final String time;
  final String phaseName;
  final String eclipse;

  MoonPhaseModel({
    required this.timestamp,
    required this.time,
    required this.phaseName,
    required this.eclipse,
  });

  factory MoonPhaseModel.fromJson(Map<String, dynamic> json) {
    return MoonPhaseModel(
      timestamp: json['timestamp'],
      time: json['time'],
      phaseName: json['phase_name'],
      eclipse: json['eclipse'],
    );
  }
}
