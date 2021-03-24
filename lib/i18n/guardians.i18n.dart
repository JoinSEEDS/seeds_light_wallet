import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Select Guardian': 'Seleccionar Guardian',
          'Next': 'Seguir',
          'Choose existing Seeds Member to add as guardians': 'Elija miembros de Seeds para agregar como guardianes',
          'Select up to 5 Guardians to invite': 'Selecciona hasta 5 guardianes para invitar ',
          'Enter user name or account': 'Ingresa nombre de cuenta',
          'Invite Guardians': 'Invitar Guardianes',
          'Send Invite': 'Enviar Invitacion',
          'The users below will be sent an invite to become your Guardian.': 'Los siguientes usuarios recibirán una invitación para convertirse en su Guardian.',
          'Invites Sent!': 'Invitaciones Enviadas',
        },
        "id_id": {
          'Select Guardian': 'Pilih Penjaga',
          'Next': 'Lanjut',
          'Choose existing Seeds Member to add as guardians': 'Pilih Anggota Seeds yang ada untuk ditambahkan sebagai penjaga',
          'Select up to 5 Guardians to invite': 'Pilih maksimal 5 Penjaga untuk diundang',
          'Enter user name or account': "Masukkan nama pengguna atau akun",
          'Invite Guardians': "Undang Penjaga",
          'Send Invite': "Kirim undangan",
          'The users below will be sent an invite to become your Guardian.': "Pengguna di bawah ini akan dikirimi undangan untuk menjadi Penjaga Anda.",
          'Invites Sent!': "Undangan Terkirim",
        }

      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
