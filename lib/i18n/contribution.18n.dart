// @dart=2.9

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Contribution Score': 'Puntos de contribución',
          'Contribution': 'Contribución',
          'Community': 'Comunidad',
          'Reputation': 'Reputación',
          'Planted': 'Plantadas',
          'Transactions': 'Transacciones',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
