import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Biometrics Disabled': 'Biométrica deshabilitada',
        'Loading your SEEDS Wallet...': 'Cargando tu SEEDS Wallet',
        'Initializing Biometrics': 'Inicializando Biométrica',
        'Enable Settings': 'Habilitar configuración',
        'Try Again': 'Intenta de nuevo',
        'Use Passcode': 'Utiliza el passcode'
      },
      "id_id": {
        'Biometrics Disabled': 'Biometrik Nonaktif',
        'Loading your SEEDS Wallet...': 'Memuat Dompet SEEDS Anda',
        'Initializing Biometrics': 'Menginisialisasi Biometrik',
        'Enable Settings': 'Aktifkan Pengaturan',
        'Try Again': 'Coba Lagi',
        'Use Passcode': 'Masukan Passkode'
      }
    };
  String get i18n => localize(this, _t);
}
