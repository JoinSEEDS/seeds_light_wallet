import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ImportKeyError { invalidPrivateKey, noAccountsFound, unableToLoadAccount, noPublicKeyFound }

extension LocalizedImportKeyError on ImportKeyError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case ImportKeyError.invalidPrivateKey:
        return localization.importKeyInvalidPrivateKeyError;
      case ImportKeyError.noAccountsFound:
        return localization.importKeyNoAccountsFoundError;
      case ImportKeyError.unableToLoadAccount:
        return localization.importKeyUnableToLoadAccountError;
      case ImportKeyError.noPublicKeyFound:
        return localization.importKeyNoPublicKeyFoundError;
    }
  }
}
