import 'package:flutter/foundation.dart';
import 'package:seeds/providers/services/http_service.dart';

class AccountGeneratorService {

  final HttpService httpService;

  AccountGeneratorService(this.httpService);

  Future<String> generateAvailable(String suggestedAccount, { int replaceWith: 1 }) async {
    final account = generate(suggestedAccount);
    final isAvailable = await httpService.isAccountNameAvailable(account);
    if(isAvailable) {
      return account;
    } else {
      final modified = modifyAccountName(account, replaceWith);
      final nextReplacement = increaseReplaceCounter(replaceWith);
      return generateAvailable(modified, replaceWith: nextReplacement);
    }
  }

  @visibleForTesting
  String modifyAccountName(String previous, int replaceWith) {
    String replacement = replaceWith.toString();
    return previous.substring(0, previous.length - replacement.length) + replacement;
  }

  @visibleForTesting
  int increaseReplaceCounter(int counter) {
    if(counter < 5) {
      return counter + 1;
    }
    return counter - 4 + 10;
  }

  static String generate(String suggestion) {
    var result = validate(suggestion);
    if(result.valid) {
      return suggestion;
    }

    if (suggestion.toLowerCase() != suggestion) {
      suggestion = suggestion.toLowerCase();
    }

    // replace 0|6|7|8|9 with 1
    if (RegExp(r'0|6|7|8|9').allMatches(suggestion).length > 0) {
      suggestion = suggestion.replaceAll(RegExp(r'0|6|7|8|9'), '');
    }

    // remove characters out of the accepted range
    suggestion = suggestion.split('').map((char) {
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(char).length > 0;

      return legalChar ? char.toString() : '';
    }).join();

    // remove the first char if it was a number
    if (suggestion?.isNotEmpty == true) {
      final illegalChar =
        RegExp(r'[a-z]').allMatches(suggestion[0]).length == 0;

      if (illegalChar) suggestion = suggestion.substring(1);
    }

    // add the missing characters.
    if (suggestion.length < 12) {
      final missingCharsCount = 12 - suggestion.length;

      final missingChars = (suggestion.hashCode.toString() * 2)
        .split('')
        .map((char) => int.parse(char).clamp(1, 5))
        .take(missingCharsCount)
        .join();

      suggestion = suggestion + missingChars;
    }

    return suggestion.substring(0, 12);
  }

  static ValidationResult validate(String accountName) {
    if (accountName.length != 12) {
      return ValidationResult.invalid('Your account name should have exactly 12 symbols');
    } else if (RegExp(r'0|6|7|8|9').allMatches(accountName).length > 0) {
      return ValidationResult.invalid('Your account name should only contain number 1-5');
    } else if (accountName.toLowerCase() != accountName) {
      return ValidationResult.invalid("Your account name should be lowercase only");
    } else if (RegExp(r'[a-z]|1|2|3|4|5').allMatches(accountName).length != 12) {
      return ValidationResult.invalid('Your account name should only contain number 1-5');
    }
    return ValidationResult.valid();
  }

}

class ValidationResult {

  final bool valid;
  final String message;

  ValidationResult(this.valid, this.message);

  ValidationResult.valid() : this(true, null);

  ValidationResult.invalid(String message) : this(false, message);

}