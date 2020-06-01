import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
         "Initialize new wallet...": "tbd",
          "Process invite link...": "tbd",
          "Accept invite from %s...": "tbd",

          // Example:
          // "Create account testact11111"
          "Create account %s...": "tbd",
          "Import account %s...": "tbd",
          "Secure wallet %s...": "tbd",

      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
