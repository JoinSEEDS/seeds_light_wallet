import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Not enough funds': 'No hay fondos suficientes',
        'Unexpected error. Please try again with a different value.': 'Error inesperado. Por favor intenta de nuevo con un valor diferente.',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
