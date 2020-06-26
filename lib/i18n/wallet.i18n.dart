import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Enter user name or account': "Ingresa nombre de cuenta",
        "Transfer": "Transferir",
        "Choose existing Seeds Member to transfer": "Escoge un miembro de Seeds para transferir",
        "Transaction hash: %s": "Hash de transacción: %s",
        'Available balance': "Balance disponible",
        'Transfer amount': "Monto a transferir",
        "Transfer amount cannot be 0.": "Monto a transferir no puede ser 0.",
        "Transfer amount is not valid.": "Monto a transferir no es válido",
        "Transfer amount cannot be greater than availabe balance.": "Monto a transferir no puede ser mayor al balance disponible",
        'Send': "Enviar",

         "Enter amount": "Ingresa monto",
         "Confirm": "Confirmar",

         'Your private key has not been backed up!': "¡Tu llave privada no ha sido respaldada en copia de seguridad!",
         'Backup': "Copia de seguridad",
         'Later': "Luego",
         'Latest transactions': "Últimas transacciones",

         'Network error': 'Error de red',
         'Pull to update': 'Tire para actualizar',
         'Exchange rate load error': 'Error de red',
         
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
