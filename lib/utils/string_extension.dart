import 'package:seeds/models/models.dart';

import 'double_extension.dart';

extension StringExtension on String{
  get seedsFormatted {
    if (this != null) {
      var parts = this.split(" ");
      var number = NumberParser.parseInput(parts[0]);
      return number.seedsFormatted;
    } else {
      return null;
    }
  }
}

