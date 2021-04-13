// @dart=2.9

import 'package:intl/intl.dart';

final fourDigitNumberFormat = NumberFormat('#,###,###,###,##0.0000');
final twoDigitNumberFormat = NumberFormat('#,###,###,###,##0.00');

extension DoubleExtension on double {
  
  String get fiatFormatted {
    if (this != null) {
      return twoDigitNumberFormat.format(this);
    } else {
      return null;
    }

  }

  String get seedsFormatted {
    if (this != null) {
      if (this != 0 && (this > 0 ? this < 1 : this > -1) ) {
        return fourDigitNumberFormat.format(this);
      } else {
        var number = (this * 100).toInt() / 100.0;
        return twoDigitNumberFormat.format(number);
      }
    } else {
      return null;
    }
  }
}
