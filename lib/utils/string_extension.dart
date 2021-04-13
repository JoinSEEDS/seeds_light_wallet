// @dart=2.9

import 'double_extension.dart';

extension StringExtension on String{
  get seedsFormatted {
    if (this != null) {
      var parts = split(' ');
      var number = double.parse(parts[0]);
      return number.seedsFormatted;
    } else {
      return null;
    }
  }
  
  String get symbolFromAmount { return split(" ")[1]; }

}

