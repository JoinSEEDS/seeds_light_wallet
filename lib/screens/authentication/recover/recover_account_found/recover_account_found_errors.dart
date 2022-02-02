import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RecoverAccountFoundError{ noGuardians, unknown}

extension LocalizedRecoverAccountErrors on RecoverAccountFoundError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case RecoverAccountFoundError.noGuardians:
        return localization.recoverAccountFoundMapperNoGuardiansError;
      case RecoverAccountFoundError.unknown:
        return localization.recoverAccountFoundMapperUnknownError;
    }
  }
}
