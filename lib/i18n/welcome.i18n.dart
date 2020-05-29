import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
      'Your wallet almost ready - choose passcode to finish setup': "tbd",
      'Welcome, %s': "tbd",
      "FINISH": "tbd",
      

      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
