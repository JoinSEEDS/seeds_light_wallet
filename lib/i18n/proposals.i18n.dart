import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        
        "Proposals": "Propuestas",
        'Staged': "Planeadas",
        "Open": "Abiertas",
        'Passed': "Aprobadas",
        'Failed': "Fallidas",

        'Created by:': "Creada por",
        'total\n%s': "votos\n%s",
        'Voted': "Votado",
        'Yes': "Sí",
        'No': "No",

        'Recipient: %s ': "Recipiente: %s ",
        'Requested: %s SEEDS': "Monto solicitado: %s SEEDS",
        'Type: %s ': "Tipo %s ",
        'Alliance': "Alliance",
        'Campaign': "Campaign",
        'Status: %s ': "Estado: %s ",
        'Stage: %s ': "Etapa: %s ",
        'URL: ': "URL: ",
        "Couldn't open this url": "No se pudo abrir este url",
        'Description': "Descripción",
        'Voting': "Votación",
        'Vote': "Votar",
        "Unexpected error, please try again": "Error inesperado, por favor intenta de nuevo",
        "You have no trust tokens": "No tienes tokens de confianza",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
