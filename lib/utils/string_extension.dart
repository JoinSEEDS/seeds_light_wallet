import 'package:intl/intl.dart';


extension StringExtension on String{
  get seedsFormatted {
    if (this != null) {
      var parts = this.split(" ");
      var number = double.parse(parts[0]);
      return number.seedsFormatted;
    } else {
      return null;
    }
  }
}

extension DoubleExtension on double {
  String get seedsFormatted {
    if (this != null) {
      var number = this;
      var showDecimals = this < 1000000;
      var seedsFormatter = showDecimals ? NumberFormat("#,###,###,###,###.####") : NumberFormat("#,###,###,###,###,###");
      return seedsFormatter.format(number);// + " " + parts[1];
    } else {
      return null;
    }
  }
}
