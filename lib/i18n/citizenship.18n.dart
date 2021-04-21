import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Progress Timeline': 'Cronograma de progreso',
          'Reputation Score': 'Puntos de reputación',
          'Visitors Invited': 'Visitantes invitados',
          'Account Age': 'Edad de la cuenta',
          'Planted Seeds': 'Semillas plantadas',
          'Transactions with Seeds': 'Transacciones con semillas',
          'Invited Users': 'Usuarios invitados',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
