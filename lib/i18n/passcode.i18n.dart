import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Delete': 'Borrar',
          'Re-enter Pincode': 'Re-ingresar código de acceso',
          'Enter Pincode': 'Ingresar código de acceso',
          'Disable Passcode': 'Deshabilita código de acceso',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
