import 'double_extension.dart';

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

