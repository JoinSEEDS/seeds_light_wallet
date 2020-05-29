import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Please enter your name': "tbd",
        'Your account name should have exactly 12 symbols': "tbd",
        'Your account name should only contain numbers 1-5': "tbd",
        "Your account name can't cont'n uppercase letters": "tbd",
        "Your account name should cont'n lower case letters": "tbd",
        'Your name': "tbd",
        'Account Name': "tbd",
        'Available: ': "tbd",
        "Create account": "tbd",
        
        // This is one sentence "your account should have exactly 12 characters..."
        // the words "exactly 12" are bold on the screen
        "Your account name should have ": "tbd",
        "exactly 12": "tbd",
        " symbols (lowercase letters and digits only 1-5)": "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
