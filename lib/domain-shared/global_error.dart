import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GlobalError { unknown }

extension LocalizedGlobalError on GlobalError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case GlobalError.unknown:
        return localization.globalUnknownError;
    }
  }
}
