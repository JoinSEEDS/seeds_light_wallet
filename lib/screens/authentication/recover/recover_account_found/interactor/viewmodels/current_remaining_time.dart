class CurrentRemainingTime {
  final int days;
  final int hours;
  final int min;
  final int sec;

  String get daysFormatted => "$days";
  String get hoursFormatted => "$hours";
  String get minFormatted => "${min < 10 ? "0" : ""}${"$min"}";
  String get secFormatted => "${sec < 10 ? "0" : ""}${"$sec"}";

  const CurrentRemainingTime({
    required this.days,
    required this.hours,
    required this.min,
    required this.sec,
  });

  factory CurrentRemainingTime.zero() => const CurrentRemainingTime(days: 0, hours: 0, min: 0, sec: 0);

  @override
  String toString() => 'CurrentRemainingTime { days: $days, hours: $hours, min: $min, sec: $sec }';
}
