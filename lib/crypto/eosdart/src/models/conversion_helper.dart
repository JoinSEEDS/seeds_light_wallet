// ignore_for_file: directives_ordering

import 'dart:typed_data';
import 'dart:convert';

mixin ConversionHelper {
  // Due to the javascript have limit on the integer, some of the numbers
  // are in String format
  // https://github.com/EOSIO/eos/issues/6820
  static int? getIntFromJson(dynamic value) {
    switch (value.runtimeType) {
      case String:
        return int.parse(value);
      default:
        return value as int?;
    }
  }

  static Uint8List base64ToBuffer(String base64String) {
    return utf8.encode(base64String);
  }

  static String bufferToBase64(Uint8List buffer) {
    return utf8.decode(buffer);
  }
}
