import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale("en_us") +
      {
        "es_es": {
          'Unexpected error. Please try again with a different value.': 'Unexpected error. Please try again with a different value.',
          'Not enough funds': 'Not enough funds'
        }
      };

  String get i18n => localize(this, _t);
}
