import 'dart:convert';


class ErrorBuilder {

  static var errorMessagesI18n = {
    'assertion failure with message: seeds: overdrawn balance': 'Not enough funds',
    'default': 'Unexpected error. Please try again with a different value.'
  };

  static String getErrorMessageKey(String resultMessage) {
    var parsedError = json.decode(resultMessage);
    if (parsedError != null) {
      var errors = parsedError['error']['details'] as List;
      for (var err in errors) {
        var errorKey = errorMessagesI18n[err['message']];
        if (errorKey != null) {
          return errorKey;
        }
      }
    }
    return errorMessagesI18n['default'];
  }
}