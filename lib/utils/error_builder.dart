

import 'dart:convert';
import 'package:seeds/i18n/error_builder.i18n.dart';

class ErrorBuilder {

  static var errorMessages = {
    'assertion failure with message: seeds: overdrawn balance': 'Not enough funds'.i18n,
    'default': 'Unexpected error. Please try again with a different value.'.i18n
  };

  static String? getErrorMessageKey(String resultMessage) {
    var parsedError = json.decode(resultMessage);
    if (parsedError != null) {
      var errors = parsedError['error']['details'] as List;
      for (var err in errors) {
        var errorKey = errorMessages[err['message']];
        if (errorKey != null) {
          return errorKey;
        }
      }
    }
    return errorMessages['default'];
  }
}