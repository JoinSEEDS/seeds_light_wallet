import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        "Private key": "tbd",
        "Paste from clipboard": "tbd",
        
        "If you already have Seeds account - enter active private key and account will be imported automatically": 
        "tbd",

        "Looking for accounts...": "tbd",
        "No accounts found associated with given key": "tbd",
        "Given private key is not valid": "tbd",
        "Account name": "tbd",
        'Import account': "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
