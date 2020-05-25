import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Better than free transactions': 'Mejor que transacciones gratis',
        "Make payments globally without any fees. Earn rewards when you support 'regenerative' organisations and people.":
        "Realice pagos a nivel mundial sin ningún cargo. Obtenga recompensas cuando apoye a organizaciones y personas 'regenerativas'.",
        'Vote directly on social and environmental impact projects you care about.':
        'Vote directamente sobre los proyectos de impacto social y ambiental que le interesan.',
        'Citizen Campaigns': 'Campañas ciudadanas',
        'Unite with a global movement of organisations and people to regenerate our planet and heal our economy.': 
        'Únete a un movimiento global de organizaciones y personas para regenerar nuestro planeta y sanar nuestra economía.',
        'Regenerative Economy': 'Economía regenerativa',
        'NEXT': 'SIGUIENTE',
        'BACK': 'ESPALDA',
        'JOIN NOW': 'ÚNETE AHORA',
      }
    };

  String get i18n => localize(this, _t);
}
