import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Enter user name or account': "tbd",
        "Transfer": "tbd",
        "Choose existing Seeds Member to transfer": "tbd",
        "Transaction hash: %s": "tbd",
        'Available balance': "tbd",
        'Transfer amount': "tbd",
        "Transfer amount cannot be 0.": "tbd",
        "Transfer amount is not valid.": "tbd",
        "Transfer amount cannot be greater than availabe balance.": "tbd",
        'Send': "tbd",

         "Enter amount": "tbd",
         "Confirm": "tbd",

         'Your private key has not been backed up!': "tbd",
         'Backup': "tbd",
         'Later': "tbd",
         'Latest transactions': "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
