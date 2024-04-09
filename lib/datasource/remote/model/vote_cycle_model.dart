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
      propcycle: json['propcycle'] as int,
      startTime: json['start_time'] as int,
      endTime: json['end_time'] as int,
      activeProps: List<int>.from(json['active_props'] as List<int>),
      evalProps: List<int>.from(json['eval_props'] as List<int>),
    );
  }
}
