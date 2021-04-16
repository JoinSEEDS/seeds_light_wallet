import 'package:flutter/services.dart';

class UserInputNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    /// oldValue is ignored and never used.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    var result = newValue.text;
    if (!result.contains(',') && !result.contains('.')) {
      return newValue;
    }

    var onlyDotsValue = result.replaceAll(',', '.');

    if ('.'.allMatches(onlyDotsValue).length == 1) {
      return newValue.copyWith(text: onlyDotsValue);
    }

    var lastIndexOfDot = onlyDotsValue.lastIndexOf('.');
    if (lastIndexOfDot == onlyDotsValue.length - 1) {
      onlyDotsValue = onlyDotsValue.substring(0, onlyDotsValue.length - 1);
      lastIndexOfDot = onlyDotsValue.lastIndexOf('.');
    }

    return newValue.copyWith(
      text: onlyDotsValue.substring(0, lastIndexOfDot).replaceAll('.', '') +
          onlyDotsValue.substring(lastIndexOfDot, onlyDotsValue.length),
    );
  }
}
