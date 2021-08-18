import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Visitor': 'Visitante',
          'Resident': 'Residente',
          'Citizen': 'Ciudadano',
          'Progress Timeline': 'Cronograma de progreso',
          'Reputation Score': 'Puntos de reputación',
          'Visitors Invited': 'Visitantes invitados',
          'Account Age': 'Edad de la cuenta',
          'Planted Seeds': 'Seeds plantadas',
          'Transactions with Seeds': 'Transacciones con seeds',
          'Invited Users': 'Usuarios invitados',
          'Residents Invited': 'Residentes Invitados',
          'Reputation Points': 'Puntos de reputación',
          'Error Loading Accounts': 'Error al cargar cuentas',
          'Error Loading Citizenship Data': 'Error al cargar datos de ciudadanía',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
