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

      /// to debug: switch between + and - 60 lines below
      /// start with +60 - then it will count down to 0, then reload
      /// then switch to -60 - it will be in wait mode, and poll every 60 seconds
      /// then switch back to +60 again - then it will exit wait mode and count down again
      endTime: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 60,
      //endTime: DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60,
      // endTime: json['end_time'], // actual code...
      activeProps: List<int>.from(json['active_props']),
      evalProps: List<int>.from(json['eval_props']),
    );
  }
}
