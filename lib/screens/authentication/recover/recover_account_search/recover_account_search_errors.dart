import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RecoverAccountSearchError { noActiveGuardians, unableToLoadGuardians, unableToLoadAccount, invalidAccount }

extension LocalizedRecoverAccountErrors on RecoverAccountSearchError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case RecoverAccountSearchError.noActiveGuardians:
        return localization.recoverAccountSearchErrorNoActiveGuardians;
      case RecoverAccountSearchError.unableToLoadGuardians:
        return localization.recoverAccountSearchErrorLoadingGuardians;
      case RecoverAccountSearchError.unableToLoadAccount:
        return localization.recoverAccountSearchErrorLoadingAccount;
      case RecoverAccountSearchError.invalidAccount:
        return localization.recoverAccountSearchErrorNoValidAccount;
    }
  }
}
