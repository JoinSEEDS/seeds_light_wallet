import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ImportKeyError { InvalidPrivateKey, NoAccountsFound, UnableToLoadAccount, NoPublicKeyFound }

extension LocalizedImportKeyError on ImportKeyError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case ImportKeyError.InvalidPrivateKey:
        return localization.importKeyInvalidPrivateKeyError;
      case ImportKeyError.NoAccountsFound:
        return localization.importKeyNoAccountsFoundError;
      case ImportKeyError.UnableToLoadAccount:
        return localization.importKeyUnableToLoadAccountError;
      case ImportKeyError.NoPublicKeyFound:
        return localization.importKeyNoPublicKeyFoundError;
    }
  }
}
