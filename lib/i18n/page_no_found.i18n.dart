import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Page Not Found': 'Página no encontrada',
          'The page you are looking for is not available':
              'La página que buscas no está disponible',
        },
        'pt_br': {
          'Page Not Found': 'Página não encontrada',
          'The page you are looking for is not available':
              'A página que está buscando não está disponível',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
