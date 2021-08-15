import 'package:flutter/services.dart';

class UserInputNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    /// oldValue is ignored and never used.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    var result = newValue.text;

    if (result.contains(',') == false && result.contains('.') == false) {
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

    result = onlyDotsValue.substring(0, lastIndexOfDot).replaceAll('.', '') +
        onlyDotsValue.substring(lastIndexOfDot, onlyDotsValue.length).toString();

    final TextSelection newSelection = newValue.selection.copyWith(
      baseOffset: result.length,
      extentOffset: result.length,
    );

    return TextEditingValue(text: result, selection: newSelection);
  }
}
