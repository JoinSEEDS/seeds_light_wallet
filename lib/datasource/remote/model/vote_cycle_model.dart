class VoteCycleModel {
  final int propcycle;
  final int startTime;
  final int endTime;
  final List<int> activeProps;
  final List<int> evalProps;

  VoteCycleModel({
    required this.propcycle,
    required this.startTime,
    required this.endTime,
    required this.activeProps,
    required this.evalProps,
  });

  factory VoteCycleModel.fromJson(Map<String, dynamic> json) {
    return VoteCycleModel(
      propcycle: json['propcycle'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      activeProps: List<int>.from(json['active_props']),
      evalProps: List<int>.from(json['eval_props']),
    );
  }
}
