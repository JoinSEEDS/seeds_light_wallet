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
        'id_id': {
          'Contribution Score': 'Kontribusi Nilai',
          'Contribution': 'Kontribusi',
          'Community': 'Komunitas',
          'Reputation': 'Reputasi',
          'Planted': 'Penanaman',
          'Transactions': 'Transaksi',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
