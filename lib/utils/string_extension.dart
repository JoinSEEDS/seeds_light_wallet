import 'package:seeds/v2/utils/double_extension.dart';
extension StringExtension on String {
  String get seedsFormatted {
    var parts = split(' ');
    var number = double.parse(parts[0]);
    return number.seedsFormatted;
  }

  String get symbolFromAmount {
    return split(" ")[1];
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
