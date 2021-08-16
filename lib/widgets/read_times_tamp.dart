import 'package:timeago/timeago.dart' as timeago;

// Link to timeago latest release
//https://pub.dev/documentation/timeago/latest/

//Link to timeago library
//https://pub.dev/documentation/timeago/latest/timeago/timeago-library.html

String timesTampToTimeAgo(DateTime timestamp) {
  final timeAgo = timeago.format(timestamp, locale: 'en');

  return timeAgo;
}

DateTime parseTimestamp(String timestamp) {
  // Note: Timestamps always come as UTC but don't have the time zone set on EOSIO
  print("-> parsing ts $timestamp");
  return DateTime.parse("${timestamp}Z");
}
