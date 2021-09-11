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
        },
        'pt_br': {
          'Contribution Score': 'Score de contribuição',
          'Contribution': 'Contribuição',
          'Community': 'Comunidade',
          'Reputation': 'Reputação',
          'Planted': 'Plantação',
          'Transactions': 'Transações',
        }

      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
