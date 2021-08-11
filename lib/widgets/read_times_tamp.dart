import 'package:timeago/timeago.dart' as timeago;

// Link to timeago latest release
//https://pub.dev/documentation/timeago/latest/

//Link to timeago library
//https://pub.dev/documentation/timeago/latest/timeago/timeago-library.html

String timesTampToTimeAgo(String timestamp) {
  // Note: Timestamps always come as UTC but don't have the time zone set on EOSIO
  final covertTimesTamp = DateTime.parse("${timestamp}Z");

  final timeAgo = timeago.format(covertTimesTamp, locale: 'en');

  return timeAgo;
}
