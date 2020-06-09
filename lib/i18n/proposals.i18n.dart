import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        
        "Proposals": "tbd",
        'Staged': "tbd",
        "Open": "tbd",
        'Passed': "tbd",
        'Failed': "tbd",

        'Created by:': "tbd",
        '%s votes': "tbd", // "27 votes"
        'Yes': "tbd",
        'No': "tbd",

        'Recipient: %s ': "tbd",
        'Requested amount: %s SEEDS': "tbd",
        'Funded by: %s ': "tbd",
        'Status: %s ': "tbd",
        'Stage: %s ': "tbd",
        'URL: ': "tbd",
        "Couldn't open this url": "tbd",
        'Description': "tbd",
        'Voting': "tbd",
        'Vote': "tbd",
        "Unexpected error, please try again": "tbd",
        "You have no trust tokens": "tbd",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
