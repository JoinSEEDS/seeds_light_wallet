import 'package:timeago/timeago.dart' as timeago;

// Link to timeago latest release
//https://pub.dev/documentation/timeago/latest/

//Link to timeago library
//https://pub.dev/documentation/timeago/latest/timeago/timeago-library.html

String timesTampToTimeAgo(String timestamp) {

  var covertTimesTamp = DateTime.parse(timestamp);
  covertTimesTamp = covertTimesTamp.toUtc();

  var timeAgo = timeago.format(covertTimesTamp, locale: 'en',);

  return timeAgo;
}




