import 'package:intl/intl.dart';

final fourDigitNumberFormat = NumberFormat('#,###,###,###,##0.00##');
final twoDigitNumberFormat = NumberFormat('#,###,###,###,##0.00');

extension DoubleExtension on double {
  String get fiatFormatted {
    return twoDigitNumberFormat.format(this);
  }

  String get seedsFormatted {
    if (this != 0 && (this > 0 ? this < 1 : this > -1)) {
      return fourDigitNumberFormat.format(this);
    } else {
      final number = (this * 100).toInt() / 100.0;
      return twoDigitNumberFormat.format(number);
    }
  }
}
