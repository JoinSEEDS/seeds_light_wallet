import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Biometrics Disabled':'Biometrics Disabled',
        'Loading your SEEDS Wallet...': 'Loading your SEEDS Wallet...',
        'Initializing Biometrics': 'Initializing Biometrics',
        'Enable Settings': 'Enable Settings',
        'Try Again': 'Try Again',
        'Use Passcode': 'Use Passcode'
      }
    };
  String get i18n => localize(this, _t);
}
