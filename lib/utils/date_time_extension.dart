import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Formatted date string that matches the user's device's language setting.
  ///
  /// Examples
  /// ```dart
  /// 'Jan 18, 2022' - ENG
  /// '18 de enero de 2022' - ESP
  /// ```
  String toYMMMMD(BuildContext context) {
    return DateFormat.yMMMMd(Localizations.localeOf(context).languageCode).format(this);
  }
}
