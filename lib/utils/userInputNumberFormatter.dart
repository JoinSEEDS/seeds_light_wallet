import 'package:flutter/services.dart';

class UserInputNumberFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

     String neww = newValue.text;

     return newValue.copyWith(text: neww.replaceAll(r',', ''));
  }


}
