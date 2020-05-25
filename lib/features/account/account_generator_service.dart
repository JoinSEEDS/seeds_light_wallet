class AccountGeneratorService {

  String generate(String input) {
    var result = validate(input);
    if(result.valid) {
      return input;
    }
    return null;
  }

  static ValidationResult validate(String accountName) {
    if (accountName.length != 12) {
      return ValidationResult.invalid('Your account name should have exactly 12 symbols');
    } else if (RegExp(r'0|6|7|8|9').allMatches(accountName).length > 0) {
      return ValidationResult.invalid('Your account name should only contain number 1-5');
    } else if (accountName.toLowerCase() != accountName) {
      return ValidationResult.invalid("Your account name can't cont'n uppercase letters");
    } else if (RegExp(r'[a-z]|1|2|3|4|5').allMatches(accountName).length != 12) {
      return ValidationResult.invalid('Your account name should only contain number 1-5');
    } else if (RegExp(r'[a-z]').allMatches(accountName[0]).length == 0) {
      return ValidationResult.invalid('Your account name should lower case letter');
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