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
        },
        'pt_br': {
          'Support': 'Suporte',
          'If you have any questions or concerns, Please find our':
              'Se tiver perguntas ou questionamentos, procure nosso',
          'Channel in': 'Canal',
          'here.': 'aqui.',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
