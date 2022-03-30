import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum ImportKeyError { invalidPrivateKey, noAccountsFound, unableToLoadAccount, noPublicKeyFound }

extension LocalizedImportKeyError on ImportKeyError {
  String localizedKeyErrorDescription(BuildContext context) {
    switch (this) {
      case ImportKeyError.invalidPrivateKey:
        return context.loc.importKeyInvalidPrivateKeyError;
      case ImportKeyError.noAccountsFound:
        return context.loc.importKeyNoAccountsFoundError;
      case ImportKeyError.unableToLoadAccount:
        return context.loc.importKeyUnableToLoadAccountError;
      case ImportKeyError.noPublicKeyFound:
        return context.loc.importKeyNoPublicKeyFoundError;
    }
  }
}
