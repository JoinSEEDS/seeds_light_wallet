import 'package:seeds/utils/double_extension.dart';

extension StringExtension on String {
  String get seedsFormatted {
    final parts = split(' ');
    final number = double.parse(parts[0]);
    return number.seedsFormatted;
  }

  String get symbolFromAmount {
    return split(" ")[1];
  }

  // convert blockchain quantity to double, e.g. "1.0000 SEEDS"
  double get quantityAsDouble {
    final parts = split(' ');
    return double.parse(parts[0]);
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
