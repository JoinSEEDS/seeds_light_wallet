import 'package:flutter/services.dart';

class UserInputNumberFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String result = newValue.text;

    if (oldValue.text.contains('.')) {
      if (newValue.text.contains(',')) {
        result = result.replaceAll(r',', '');
      }
    } //only way this is true is if user copy and paste a number
    else if (newValue.text.contains(',') && newValue.text.contains('.')) {
      //Decimal will be the last one in the string
      if (newValue.text.lastIndexOf(',') > newValue.text.lastIndexOf('.')) {
        result = result.replaceAll(r'.', '');
      } else {
        result = result.replaceAll(r',', '');
      }
      //User will only be able to enter a '.' for decimal use, and if they enter a ',' will be change for a '.'
    }

    if (oldValue.text.contains('.')) {
      if (newValue.text.contains(',')) {
        result = result.replaceAll(r',', '');
      }
    }

    if (newValue.text.contains(',')) {
      result = result.replaceAll(r',', '.');
    }

    if (oldValue.text.contains('.')) {
      if (oldValue.text.length < newValue.text.length) {
        if (newValue.text.contains('.', oldValue.selection.end)) {
          result = oldValue.text;
        }
      }
    }

    return newValue.copyWith(text: result);
  }
}
