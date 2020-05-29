import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Full Name': "tbd",
        'Enter your name': "tbd", 
        "Name cannot be empty": "tbd",
        'Save': "tbd",
        "Terms & Conditions": "tbd",
        'Privacy Policy': "tbd",
        'Export private key': "tbd",
        'Logout': "tbd",
        'Choose Picture': "tbd",
        'Take a picture': "tbd",
        'Profile updated successfully.': "tbd",
        'An error occured, please try again.': "tbd",
        'Save private key in secure place - to be able to restore access to your wallet later': "tbd",
        "Save private key": "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
