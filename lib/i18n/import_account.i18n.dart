import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Private key': 'Llave privada',
        'Paste from clipboard': 'Pegar del portapapeles',
        
        'If you already have Seeds account - enter active private key and account will be imported automatically': 
        'Si ya tienes una cuenta de Seeds - ingresa tu llave privada activa y tu cuenta se importará automáticamente',

        'Looking for accounts...': 'Buscando cuentas...',
        'No accounts found associated with given key': 'No se encontraron cuentas asociadas a esta llave',
        'Given private key is not valid': 'La llave privada no es válida',
        'Account name': 'Nombre de cuenta',
        'Import account': 'Importar cuenta',
      },
      "id_id": {
        "Private key": "Kunci Pribadi",
        "Paste from clipboard": "Tempel",
        
        "If you already have Seeds account - enter active private key and account will be imported automatically": 
        "Jika Anda sudah memiliki akun Seeds - masukkan kunci pribadi aktif dan akun akan diimpor secara otomatis",

        "Looking for accounts...": "Mencari akun...",
        "No accounts found associated with given key": "Tidak ada akun yang ditemukan terkait dengan kunci yang diberikan",
        "Given private key is not valid": "Kunci pribadi yang diberikan tidak valid",
        "Account name": "Nama akun",
        'Import account': "Impor akun",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
