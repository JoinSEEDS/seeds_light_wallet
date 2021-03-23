import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Invite code (5 words)': 'Código de invitación (5 palabras)',
        'Paste from clipboard': 'Pegar desde el portapapeles',
        'If you received invite from another Seeds member - enter secret words and it will be claimed automatically':
        'Si recibiste la invitación de otro miembro de Seeds - ingresa las palabras secretas y será reclamado automáticamente',
        'Looking for invite...': 'Buscando la invitación...',
        'Network not available, try later':'Red no disponible, intenta luego',
        'No invites found, try another code': 'No se encontró la invitación, intenta otro código',

        // Example:
        // "Invite of Mike already claimed by Joe"
        'Invite of %s already claimed by %s':'Invitación de %s ya fue reclamada por %s',
        
        // Example:
        //"Congratulations! You are invited by Mike - 10 SEEDS will be transferred and 5 SEEDS will be planted to your account - continue to create an account":
        'Congratulations! You are invited by %s - %s will be transferred and %s will be planted to your account - continue to create an account':
        '¡Felicidades! Fuiste invitado por %s - %s serán transferidos y %s serán plantados en tu cuenta - continúa a crear la cuenta',

        'Claim code': 'Código de reclamo',
      },
      "id_id": {
        "Invite code (5 words)": "Kode undang (5 kata-kata)",
        "Paste from clipboard": "Tempel",
        "If you received invite from another Seeds member - enter secret words and it will be claimed automatically":
        "Jika Anda menerima undangan dari anggota Seeds lain - masukkan kata-kata rahasia dan itu akan diklaim secara otomatis",
        "Looking for invite...": "Mencari undangan...",
        "Network not available, try later":"Jaringan tidak tersedia, coba lagi nanti",
        "No invites found, try another code": "Tidak ada undangan yang ditemukan, coba kode lain",

        // Example:
        // "Invite of Mike already claimed by Joe"
        "Invite of %s already claimed by %s":"Undangan dari %s sudah diklaim oleh %s",
        
        // Example:
        //"Congratulations! You are invited by Mike - 10 SEEDS will be transferred and 5 SEEDS will be planted to your account - continue to create an account":
        "Congratulations! You are invited by %s - %s will be transferred and %s will be planted to your account - continue to create an account":
        "Selamat! Anda diundang oleh %s - %s akan ditransfer dan %s akan ditanamkan ke akun Anda - lanjutkan membuat akun",

        'Claim code': "klaim kode",
      }

    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
