import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        
        "Invites": "tbd",
        "Members invited by you:": "tbd",
        "Active invites:": "tbd",
        "%s (copy)": "tbd", // copy tx hash
        "Sow: %s": "tbd",
        "Transfer: %s": "tbd",
        "No active invites": "tbd",
        "Create new invite": "tbd",

        "Transaction hash: %s": "tbd",
        "Show invite code": "tbd",
        "Invite friend": "tbd",
        "Invite amount (minimum: 5)": "tbd",
        "Create invite": "tbd",
        "GREAT": "tbd",
        "Share this link with the person you want to invite!": "tbd",
        "Share Link": "tbd",
        "Share Code": "tbd",
        "Done": "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
