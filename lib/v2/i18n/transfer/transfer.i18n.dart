import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          "Scan QR Code": 'Escanear Código QR',
          'Share Link to Invoice': 'Compartir enlace a la factura',
          "Total": 'Total',
          'Memo:': 'Memo:',
          'Done': 'Hecho',
          "Receive": 'Recibir',
          'Receive creation failed, please try again.': 'Se produjo un error. Vuelve a intentarlo.',
          "Memo": 'Memo',
          "Add a note": 'Agrega una nota',
          "Available Balance": 'Saldo disponible',
          'Next': 'Próximo',
          "Choose an option": 'Escoge una opción',
          "Input Seeds or Other Currency":"Entra Seeds o otra moneda",
          "Select a Product or Service": "Seleccione un producto o servicio",
          "Confirm and Send": 'Confirmar y Enviar',
          'Close': 'Cerrar',
          "To": 'Para',
          "From": 'Desde',
          'Date:  ': 'Fecha:  ',
          'Transaction ID:  ': 'ID de transacción:  ',
          "Copied": 'Copiado',
          'Status:  ': 'Estado:  ',
          "Successful": 'Exitoso',
          "Send": 'Enviar',
          "Send to": 'Enviar a',
          'Not enough balance': 'No hay suficiente saldo',
          "Edit":'Editar',
          "Network Fee": 'Tarifa de envio',
          "Always Free and Instant!": "Siempre sin cargos e instantánea!",
          "Scan QR Code to Send": "Escanear El Código QR Para Enviar",
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
