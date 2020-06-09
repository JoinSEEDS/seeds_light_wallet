import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'You can ask for an invite at': "tbd",
        "Membership based on Web of Trust": "tbd",
        "By signing up, you agree to our terms and privacy policy": "tbd",
        'Terms & Conditions': "tbd",
        'Privacy Policy': "tbd",
        'If you have an account\nclick here': "tbd",
        'Import private key': "tbd",
        'If you have an invite\nclick here': "tbd",
        "Claim invite code": "Claim invite code",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
