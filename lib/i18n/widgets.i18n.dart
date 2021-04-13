// @dart=2.9

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Available balance': 'Balance disponible',
        'Paste from clipboard': 'Pegar del portapapeles',
        'ONLINE (connected to %s)': 'EN LÍNEA (conectado a %s)',
        'OFFLINE (trying to reconnect)': 'FUERA DE LÍNEA (intentando reconectar)',

        'Transaction successful': 'Transacción exitosa',
        'Transaction failed': 'Transacción fallida',
        'Done': 'Listo',

        'Page Not Found': 'Página no encontrada',
        'The page you are looking for is not available': 'La página que buscas no está disponible',

        'Delete': 'Borrar',
        'Enter Passcode': 'Ingresar código de acceso',
        'Choose Passcode': 'Escoge código de acceso',
        'Disable Passcode': 'Deshabilita código de acceso',

        'Planted balance': 'Balance plantado',

        'Telos balance': 'Balance Telos',

        'Transaction hash: %s': 'Hash de transacción: %s',
        'Transfer amount': 'Monto a transferir',
        'Send': 'Enviar',
        'Back': 'Atrás',
        'Explore': 'Explorar',
        'Wallet': 'Billetera',
        'Profile': 'Perfil',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
