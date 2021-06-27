import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Created by:': 'Creada por',
          'Recipient: %s ': 'Recipiente: %s ',
          'Requested: %s ': 'Monto solicitado: %s ',
          'Type: %s ': 'Tipo %s ',
          'Alliance': 'Alliance',
          'Campaign': 'Campaign',
          'Status: %s ': 'Estado: %s ',
          'Stage: %s ': 'Etapa: %s ',
          'URL: ': 'URL: ',
          "Couldn't open this url": 'No se pudo abrir este url',
          'Description': 'Descripción',
          'Precast your Vote': 'Predefina su voto',
          'Yes': 'Sí',
          'Abstain': 'Abstenerse',
          'No': 'No',
          'You have no trust tokens': 'No tienes tokens de confianza',
          'Confirm': 'Confirmar',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
