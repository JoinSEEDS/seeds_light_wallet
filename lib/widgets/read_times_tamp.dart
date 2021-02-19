import 'package:timeago/timeago.dart' as timeago;

String readTimestamp(String timestamp) {

  var covertTimesTamp = DateTime.parse(timestamp);
  covertTimesTamp = covertTimesTamp.toUtc();

  var timeAgo = timeago.format(covertTimesTamp, locale: 'en',);

  return timeAgo;
}




