class CurrentRemainingTime {
  final int days;
  final int hours;
  final int min;
  final int sec;

  const CurrentRemainingTime({
    required this.days,
    required this.hours,
    required this.min,
    required this.sec,
  });

  @override
  String toString() => 'CurrentRemainingTime { days: $days, hours: $hours, min: $min, sec: $sec }';
}
