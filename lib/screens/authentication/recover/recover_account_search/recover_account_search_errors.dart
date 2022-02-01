import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RecoverAccountSearchError { NoActiveGuardians, UnableToLoadGuardians, UnableToLoadAccount, InvalidAccount }

extension LocalizedRecoverAccountErrors on RecoverAccountSearchError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case RecoverAccountSearchError.NoActiveGuardians:
        return localization.recoverAccountSearchErrorNoActiveGuardians;
      case RecoverAccountSearchError.UnableToLoadGuardians:
        return localization.recoverAccountSearchErrorLoadingGuardians;
      case RecoverAccountSearchError.UnableToLoadAccount:
        return localization.recoverAccountSearchErrorLoadingAccount;
      case RecoverAccountSearchError.InvalidAccount:
        return localization.recoverAccountSearchErrorNoValidAccount;
    }
  }
}
