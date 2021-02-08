import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String readTimestamp(String timestamp) {
  var currentDate = DateTime.now();
  var time2 = DateTime.parse(timestamp);
  var format = time2.toUtc().toIso8601String();

  var differecnce = currentDate.difference(time2).inDays;
  var differecnce1 = currentDate.difference(DateTime.parse(format)).inMinutes;
  var differecnce2 = currentDate.difference(time2).inHours;

  var date = DateTime.fromMillisecondsSinceEpoch(time2.microsecondsSinceEpoch);
  var diff = currentDate.difference(time2);
  final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 2));

  DateTime timee = DateTime.parse('$format');

  //var time = timeago.format(timee);
   time2 = time2.toUtc();
   var convertedDate = time2.toLocal();
  var df = DateFormat("EEE dd MMM y kk:mm:ss");
  final time4 = df.format(DateTime.tryParse(timestamp));

  //var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
  //var dateLocal = dateTime.toLocal();
  var dateUtc = DateTime.now().toUtc();
  var dateLocal = time2.toLocal();
 // vae day = df.parseUTC(timestamp.toString());
  //var time = timeago.format(DateTime.parse(time4));
 // String currentPattern = "EEE MMM dd kk:mm:ss z yyyy";
 // DateFormat sdf = DateFormat( currentPattern);
  //var time = sdf.parse(timestamp);

  var time = timeago.format(time2, locale: 'en',);


  //TimeAgo.timeAgoSinceDate(timestamp);
  //StringExtension.displayTimeAgoFromTimestamp(timestamp);
  return time;
}
// send tequila at 9:28pm
// 	GMT — Greenwich Mean Time
//	5 hours ahead of Miami
//  No UTC/GMT offset

extension StringExtension on String {
  static String displayTimeAgoFromTimestamp(String timestamp) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'minute';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hour';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }
}


