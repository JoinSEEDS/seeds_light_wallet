import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Explore': 'Explorar',
          'Invite a Friend': 'Invita un amigo',
          'Planted Seeds': 'Seeds plantadas',
          'Vote': 'Votar',
          'Get Seeds': 'Obtener Seeds',
          'Error Loading Page': 'Error Cargando La página'
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
