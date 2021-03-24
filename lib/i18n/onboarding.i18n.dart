import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Better than free transactions': 'Transacciones mejor que gratis',
        "Make payments globally without any fees. Earn rewards when you support 'regenerative' organisations and people.":
        "Realiza pagos a nivel mundial sin ningún cargo. Obtenga recompensas cuando apoye a organizaciones y personas 'regenerativas'.",
        'Vote directly on social and environmental impact projects you care about.':
        'Vota directamente sobre los proyectos de impacto social y ambiental que te interesan.',
        'Citizen Campaigns': 'Campañas ciudadanas',
        'Unite with a global movement of organisations and people to regenerate our planet and heal our economy.': 
        'Únete a un movimiento global de organizaciones y personas para regenerar nuestro planeta y sanar nuestra economía.',
        'Regenerative Economy': 'Economía regenerativa',
        'NEXT': 'SIGUIENTE',
        'BACK': 'ATRÁS',
        'JOIN NOW': 'ÚNETE AHORA',
      },
      "id_id": {
        'Better than free transactions': 'Lebih baik daripada transaksi gratis',
        "Make payments globally without any fees. Earn rewards when you support 'regenerative' organisations and people.":
        "Lakukan pembayaran secara global tanpa biaya apa pun. Dapatkan imbalan jika Anda mendukung organisasi dan orang 'regeneratif''.",
        'Vote directly on social and environmental impact projects you care about.':
        'Beri suara langsung pada proyek dampak sosial dan lingkungan yang Anda pedulikan.',
        'Citizen Campaigns': 'Kampanye Warga',
        'Unite with a global movement of organisations and people to regenerate our planet and heal our economy.': 
        'Bersatu dengan gerakan global organisasi dan orang-orang untuk meregenerasi planet kita dan memulihkan ekonomi kita.',
        'Regenerative Economy': 'Ekonomi Regeneratif',
        'NEXT': 'Lanjut',
        'BACK': 'KEMBALI',
        'JOIN NOW': 'GABUNG SEKARANG',
      }
    };

  String get i18n => localize(this, _t);
}
