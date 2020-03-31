import 'package:intl/intl.dart';


extension StringExtension on String{
  get quantityFormatted {
    if (this != null) {
      var parts = this.split(" ");
      var number = double.parse(parts[0]);
      //number = number + 30000000.0007; // debug
      var showDecimals = number < 1000000;
      var quantityFormatter = showDecimals ? NumberFormat("#,###,###,###,###.####") : NumberFormat("#,###,###,###,###,###");
      return quantityFormatter.format(number);// + " " + parts[1];
    } else {
      return null;
    }
  }
}
