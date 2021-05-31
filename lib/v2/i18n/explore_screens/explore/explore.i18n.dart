import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Explore': 'Explorar',
          'Invite': 'Invitación',
          'Available Seeds': 'Seeds Disponibles',
          'Plant': 'Plantar',
          'Plant Seeds': 'Plantar Seeds',
          'Vote': 'Votar',
          'Get Seeds': 'Obtener Seeds',
          'Error Loading Data': 'Error Cargando Los Datos',
          'Error Loading Page': 'Error Cargando La página'
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
