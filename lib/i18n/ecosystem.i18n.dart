import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Vote': 'Propuestas - Votar',
        'Tap to participate': 'Toca para participar',
        'Trust Tokens': 'Tokens de Confianza',

        'Invite': 'Invitar',
        'Tap to send an invite': 'Toca para enviar invitación',
        'Available Seeds': 'Seeds disponibles',
        
        'Plant': 'Planta',
        'Tap to plant Seeds': 'Toca para plantar Seeds',
        'Planted Seeds': 'Seeds plantadas',

        'Sow: %s Transfer: %s': 'Siembra: %s Transfiere: %s',
        'Copy': 'Copiar',
        'Cancel': 'Cancelar',
        'Your invites': 'Tus invitaciones',
        'Build community - gain reputation': 'Construye comunidad - gana reputación',
      },
      "id_id": {
        "Vote": "Pilih",
        "Tap to participate": "klik untuk berpartisipasi",
        "Trust Tokens": "Token Percaya",

        "Invite": "Undang",
        "Tap to send an invite": "Klik untuk mengirim undangan",
        "Available Seeds": "Seeds tersedia",
        
        "Plant": "Menanam",
        "Tap to plant Seeds": "Klik untuk menanam Seeds",
        "Planted Seeds": "Seeds yang Ditanam",

        "Sow: %s Transfer: %s": "Tabur: %s Mengirim: %s",
        "Copy": "Salinan",
        "Cancel": "Membatalkan",
        "Your invites": "Undangan Anda",
        "Build community - gain reputation": "Bangun komunitas - dapatkan reputasi",
      }

    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
