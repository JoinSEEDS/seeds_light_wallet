import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  /// Returns the localization instance
  AppLocalizations get loc => AppLocalizations.of(this);
}
