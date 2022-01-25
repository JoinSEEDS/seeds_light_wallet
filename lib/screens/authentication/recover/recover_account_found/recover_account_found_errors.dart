import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RecoverAccountFoundError{ NoGuardians, Unknown}

extension LocalizedRecoverAccountErrors on RecoverAccountFoundError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case RecoverAccountFoundError.NoGuardians:
        return localization.recoverAccountFoundMapperNoGuardiansError;
      case RecoverAccountFoundError.Unknown:
        return localization.recoverAccountFoundMapperUnknownError;
    }
  }
}
