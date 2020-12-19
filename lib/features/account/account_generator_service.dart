import 'package:flutter/foundation.dart';
import 'package:seeds/providers/services/http_service.dart';

class AccountGeneratorService {
  HttpService _httpService;

  AccountGeneratorService();

  update(HttpService httpService) {
    this._httpService = httpService;
  }

  Future<List<String>> generateList(String suggestedAccount,
      {int count: 4}) async {
    List<String> available = [];
    List<String> excludes = [];
    for (int i = 0; i < count; i++) {
      final result = await findAvailable(suggestedAccount, exclude: excludes);
      available.add(result.available);
      excludes.addAll(result.all);
    }
    return available;
  }

  Future<List<String>> alternativeAccountsList(String baseAccount,
      {int count: 4}) async {
    List<String> available = [];
    List<String> excludes = [baseAccount];
    for (int i = 0; i < count; i++) {
      final result = await findAvailable(baseAccount, exclude: excludes);
      available.add(result.available);
      excludes.addAll(result.all);
    }
    return available;
  }

  static const List<String> empty = [];

  Future<AccountAvailableResult> findAvailable(String suggestedAccount,
      {int replaceWith: 1,
      List<String> exclude,
      int recursionAttempts: 40}) async {
    final account = convert(suggestedAccount);
    if (exclude == null) {
      exclude = [];
    }

    if (!exclude.contains(account)) {
      final isAvailable = await availableOnChain(account);
      if (isAvailable) {
        return AccountAvailableResult(
          available: account,
          unavailable: exclude,
        );
      }
    }

    if (recursionAttempts <= 0) {
      return Future.error("Couldn't find a valid account name");
    }
    exclude.add(account);
    final modified = modifyAccountName(account, replaceWith);
    final nextReplacement = increaseReplaceCounter(replaceWith);

    return findAvailable(modified,
        replaceWith: nextReplacement,
        exclude: exclude,
        recursionAttempts: recursionAttempts - 1);
  }

  Future<bool> availableOnChain(String account) {
    if (validate(account).valid) {
      return _httpService.isAccountNameAvailable(account);
    }
    return Future.value(false);
  }

  @visibleForTesting
  String modifyAccountName(String previous, int replaceWith) {
    String replacement = replaceWith.toString();
    return previous.substring(0, previous.length - replacement.length) +
        replacement;
  }

  @visibleForTesting
  int increaseReplaceCounter(int counter) {
    var str = counter.toString();
    int modify = 0;

    int multiplier = 1;
    for (int i = str.length; i > 0; i--) {
      var x = int.parse(str[i - 1]);
      if (x < 5) {
        modify += 1 * multiplier;
        break;
      } else if (i == 1) {
        modify += 6 * multiplier;
      } else {
        modify -= 4 * multiplier;
      }

      multiplier *= 10;
    }

    return counter + modify;
  }

  // is convert a better name?
  String convert(String suggestion) {
    var result = validate(suggestion);
    if (result.valid) {
      return suggestion;
    }

    suggestion = suggestion.toLowerCase();

    // replace 0|6|7|8|9 with 1
    if (RegExp(r'0|6|7|8|9').allMatches(suggestion).length > 0) {
      suggestion = suggestion.replaceAll(RegExp(r'0|6|7|8|9'), '');
    }

    // remove characters out of the accepted range
    suggestion = suggestion.split('').map((char) {
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(char).length > 0;

      return legalChar ? char.toString() : '';
    }).join();

    // if first char is a number, start with 'a'
    if (suggestion?.isNotEmpty == true) {
      final illegalChar =
          RegExp(r'[a-z]').allMatches(suggestion[0]).length == 0;

      if (illegalChar) suggestion = 'a' + suggestion;
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
}

String validator(String accountName) => validate(accountName).validation;

ValidationResult validate(String accountName) {
  var validCharacters = RegExp(r'^[a-z1-5]+$');

  if (RegExp(r'0|6|7|8|9').allMatches(accountName).length > 0) {
    return ValidationResult.invalid('Name can only contain numbers 1-5');
  } else if (accountName.toLowerCase() != accountName) {
    return ValidationResult.invalid("Name can be lowercase only");
  } else if (accountName.contains(' ')) {
    return ValidationResult.invalid("Name can't have space");
  } else if (accountName.contains('@')) {
    return ValidationResult.invalid("Name can't have @");
  } else if (!validCharacters.hasMatch(accountName)) {
    return ValidationResult.invalid("Name can't have special characters");
  } else if (accountName.length != 12) {
    return ValidationResult.invalid('Name should have 12 symbols');
  } else if (RegExp(r'[a-z]|1|2|3|4|5').allMatches(accountName).length != 12) {
    return ValidationResult.invalid('Only letters a..z and numbers 1..5');
  }
  return ValidationResult.valid();
}

class ValidationResult {
  final bool valid;
  final String message;
  String get validation => valid ? null : message;
  bool get invalid => !valid;

  ValidationResult(this.valid, this.message);

  ValidationResult.valid() : this(true, null);

  ValidationResult.invalid(String message) : this(false, message);
}

class AccountAvailableResult {
  final String available;
  final List<String> unavailable;
  List<String> get all => [available, ...unavailable];

  AccountAvailableResult({this.available, this.unavailable: const []});
}
