class CurrentRemainingTime {
  final int? days;
  final int? hours;
  final int? min;
  final int? sec;

  const CurrentRemainingTime({this.days, this.hours, this.min, this.sec});

  @override
  String toString() => 'CurrentRemainingTime { days: $days, hours: $hours, min: $min, sec: $sec }';
}
