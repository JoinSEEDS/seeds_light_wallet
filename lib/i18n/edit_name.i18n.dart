import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Edit Display Name': 'Editar nombre a mostrar',
          'Save Changes': 'Guardar cambios',
          'Display name': 'Nombre a mostrar',
          'Please enter a smaller name': 'Por favor ingrese un nombre mas corto.'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
