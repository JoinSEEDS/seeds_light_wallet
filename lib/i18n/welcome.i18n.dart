import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
      'Your wallet almost ready - choose passcode to finish setup': "Tu billetera está casi lista - escoge un código de seguridad para finalizar",
      'Welcome, %s': "Bienvenido, %s",
      "FINISH": "FINALIZAR",
      

      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
