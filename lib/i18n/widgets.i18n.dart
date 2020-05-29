import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Available balance': "tbd",
        "Paste from clipboard": "tbd",
        "ONLINE (connected to %s)": "tbd",
        'OFFLINE (trying to reconnect)': "tbd",

        "Transaction successful": "tbd",
        "Transaction failed": "tbd",
        "Done": "tbd",

        'Page Not Found': "tbd",
        'The page you are looking for is not available': "tbd",

        "Delete": "tbd",
        "Enter Passcode": "tbd",
        "Choose Passcode": "tbd",
        "Disable Passcode": "tbd",

        'Planted balance': "tbd",

        'Telos balance': "tbd",

        "Transaction hash: %s": "tbd",
        'Transfer amount': "tbd",
        'Send': "tbd",
        //'Available balance': "tbd",



      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
