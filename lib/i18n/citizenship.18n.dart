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
          'Friends Invited': 'Amigos invitados',
        },
        'id_id': {
          'Progress Timeline': 'Kemajuan Timeline',
          'Reputation Score': 'Reputasi Nilai',
          'Visitors Invited': 'Pengunjung yang diundang',
          'Account Age': 'Usia akun',
          'Planted Seeds': 'Seeds yang ditanam',
          'Transactions with Seeds': 'Transaksi dengan Seeds',
          'Friends Invited': 'Teman yang diundang',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
