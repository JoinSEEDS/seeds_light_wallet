import 'double_extension.dart';

extension StringExtension on String {
  String? get seedsFormatted {
    var parts = split(' ');
    var number = double.parse(parts[0]);
    return number.seedsFormatted;
  }

  String get symbolFromAmount {
    return split(" ")[1];
  }
}
