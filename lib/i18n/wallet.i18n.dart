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
        'Receive': "Recibir",

         "Enter amount": "Ingresa monto",
         "Confirm": "Confirmar",
         'Pay %s SEEDS to %s':'Pagar %s SEEDS a %s',
         "Done": "Hecho",

         'Your private key has not been backed up!': "¡Tu llave privada no ha sido respaldada en copia de seguridad!",
         'Backup': "Copia de seguridad",
         'Later': "Luego",
         'Latest transactions': "Últimas transacciones",

         'Network error': 'Error de red',
         'Pull to update': 'Tire para actualizar',
         'Exchange rate load error': 'Error de red',

         'Add Product': 'Agregar Producto',
         'Price needs to be a number': 'Precio tiene que ser un numero',
         'Price field is empty': 'Ingrese un numero',
         'Price': 'Precio',
         'Name cannot be empty': 'Ingrese un nombre',
         'Name': 'Nombre',
         'Edit Product': 'Editar Producto',
         'Add Picture': 'Agregar Foto',
         'Change Picture': 'Cambiar Foto',
         'Delete': 'Eliminar',
        
         'Memo (optional)': 'Memo (opcional)',
         "What's it for?": "Para que es?"


      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
