// @dart=2.9

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Support': 'Soporte',
          'If you have any questions or concerns, Please find our':
              'Si tiene alguna pregunta o inquietud, busque nuestro',
          'Channel in': 'Canal en',
          'here.': 'aqui.',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
