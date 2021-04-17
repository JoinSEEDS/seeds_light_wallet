import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Delete': 'Borrar',
          'Re-enter Pincode': 'Re-ingresar código de acceso',
          'Create Pincode': 'Crear código de acceso',
          'Unlock': 'Desbloquear',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
