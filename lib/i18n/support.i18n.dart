import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Support': 'Soporte',
          'If you have any questions or concerns, Please find our':
              'Si tiene alguna pregunta o inquietud, busque nuestro',
          'Channel in': 'Canal en', // TODO this looks weird - check this
          'here.': 'aqui.',
        },        
        'id_id': {
          'Support': 'Dukungan',
          'If you have any questions or concerns, Please find our':
              'Jika Anda memiliki pertanyaan atau masalah, Silakan temukan kami',
          'Channel in': 'Channel in',
          'here.': 'di sini.',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
