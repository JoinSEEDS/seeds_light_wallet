import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
         'Please enable camera access to scan QR code': 'Habilite el acceso a la cámara para escanear el código QR',
         'Try Again':'Volver a probar'
      },
      "id_id": {
         "Please enable camera access to scan QR code": "Aktifkan akses kamera untuk memindai kode QR",
         'Try Again':"Coba Lagi"
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
