import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          // TRANSLATION NOTE: These are automatic translations by Google Translate - please replace

          'Better \nThan Free Transactions': 'Transacciones mejor que gratis',
          'Make payments globally without any fees. Earn rewards when you support ‘Regenerative’ organizations and people.':
              "Realiza pagos a nivel mundial sin ningún cargo. Obtenga recompensas cuando apoye a organizaciones y personas 'regenerativas'.",
          'Participate and vote directly on social and environmental impact projects you care about.':
              'Participa y vota directamente en proyectos de impacto social y ambiental que te interesen.',
          'Citizen Campaigns': 'Campañas ciudadanas',
          'Unite with a global movement of organizations and people to regenerate our planet and heal our economy.':
              'Únete a un movimiento global de organizaciones y personas para regenerar nuestro planeta y sanar nuestra economía.',
          'Regenerative Economy': 'Economía regenerativa',
          'NEXT': 'SIGUIENTE',
          'BACK': 'ATRÁS',
          'Join Now': 'Únete ahora',
        }
      };

  String get i18n => localize(this, _t);
}
