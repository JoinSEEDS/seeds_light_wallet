import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Created by': 'Creada por',
          'Recipient: %s ': 'Recipiente: %s ',
          'Requested: %s ': 'Monto solicitado: %s ',
          'Type: %s ': 'Tipo: %s ',
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
          'Vote': 'Votar',
          'Vote ': 'Voto ',
          'Votes': 'Votos',
          'Confirm': 'Confirmar',
          'Voting for this proposal is not open yet.': 'La votación para esta propuesta aún no está abierta.',
          'View Next Proposal': 'Ver siguiente propuesta',
          'You must be a': 'Debes ser un',
          ' Citizen ': ' Ciudadano ',
          'to vote on proposals.': 'para votar en propuestas.',
          'You have already': 'Ya has',
          ' Voted with ': ' Votado con ',
          'Voting': 'Votar',
          'You have already used your': 'Ya has usado tus',
          ' Trust Tokens ': ' Fichas de confianza ',
          'for this cycle.': 'para este ciclo.',
          "I'm": "Estoy",
          ' in favor ': ' en favor ',
          'of this proposal': 'de esta propuesta',
          'I': 'Me',
          ' refrain ': ' abstengo ',
          'from voting': 'de votar',
          ' against ': ' en contra ',
          'this proposal': 'de esta propuesta',
          'Cancel': 'Cancelar',
          'Confirm your Vote': 'Confirma tu Voto',
          'Your trust tokens cannot be reallocated afterwards so please be sure of your vote!':
              'Sus tokens de confianza no se pueden reasignar después, ¡Por Favor asegúrese de su voto!',
          'Done': 'Hecho',
          'Thank you!': '¡Gracias!',
          'Thank you for coming and contributing your voice to the collective decision making process. Please make sure to come back at the start of the next Voting Cycle to empower more people!':
              'Gracias por venir y contribuir con su voz al proceso de toma de decisiones colectivas. ¡Asegúrese de regresar al comienzo del próximo ciclo de votación para empoderar a más personas!',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
