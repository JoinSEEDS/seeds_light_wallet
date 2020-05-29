import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        "Proposals - Vote": "tbd",
        "Tap to participate": "tbd",
        "Trust Tokens": "tbd",

        "Community - Invite": "tbd",
        "Tap to send an invite": "tbd",
        "Available Seeds": "tbd",
        
        "Harvest - Plant": "tbd",
        "Tap to plant Seeds": "tbd",
        "Planted Seeds": "tbd",

        "Sow: %s Transfer: %s": "tbd",
        "Copy": "tbd",
        "Cancel": "tbd",
        "Your invites": "tbd",
        "Build community - gain reputation": "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
