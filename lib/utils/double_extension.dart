import 'package:intl/intl.dart';

extension DoubleExtension on double {
  
  String get fiatFormatted {
    if (this != null) {
      var number = this;
      var fiatFormatter = NumberFormat("#,###,###,###,###.##");
      return fiatFormatter.format(number);// + " " + parts[1];
    } else {
      return null;
    }

  }

  String get seedsFormatted {
    if (this != null) {
      var number = this;
      number = 0.0042;
      var showDecimals = this < 1000000;
      var seedsFormatter = showDecimals ? 
        number < 0.01 ? NumberFormat("#.####") : NumberFormat("#,###,###,###,###.##") 
        : NumberFormat("#,###,###,###,###,###");
      return seedsFormatter.format(number);
    } else {
      return null;
    }
  }
}
