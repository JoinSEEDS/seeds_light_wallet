import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Join Now': 'Únete ahora',
          "Better \nThan Free Transcations": 'Mejor \nQue Transcciones Gratis',
          "Make payments globally without any fees. Earn rewards when you support ‘Regenerative’ organisations and people.":
              "Realiza pagos a nivel mundial sin ningún cargo. Obtenga recompensas cuando apoye a organizaciones y personas 'regenerativas'.",
          "Citizen Campaigns": 'Campañas ciudadanas',
          "Participate and vote directly on social and environmental impact projects you care about.":
              'Participa y vota directamente en proyectos de impacto social y ambiental que te interesen.',
          "Regenerative Economy": 'Economía Regenerativa',
          "Unite with a global movement of organisations and people to regenerate our planet and heal our economy.":
              'Únete a un movimiento global de organizaciones y personas para regenerar nuestro planeta y sanar nuestra economía.',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
