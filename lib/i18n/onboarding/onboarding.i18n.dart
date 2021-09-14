import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Join Now': 'Únete ahora',
          "Better\nThan Free\nTransactions": 'Mejor\nQue Transacciones\nGratis',
          "Make payments globally without any fees.\nEarn rewards when you support\n‘Regenerative’ organizations and people.":
              "Realiza pagos a nivel mundial sin ningún cargo.\nObtenga recompensas cuando apoye a\norganizaciones y personas 'regenerativas'.",
          "Citizen\nCampaigns": 'Campañas\nCiudadanas',
          "Participate and vote directly on social and\nenvironmental impact projects you care\nabout.":
              'Participa y vota directamente en proyectos\nde impacto social y ambiental que te\ninteresen.',
          "Regenerative\nEconomy": 'Economía\nRegenerativa',
          "Unite with a global movement of\norganizations and people to regenerate our\nplanet and heal our economy.":
              'Únete a un movimiento global de\norganizaciones y personas para regenerar\nnuestro planeta y sanar nuestra economía.',
        },
        'pt_br': {
          'Join Now': 'Entrar agora',
          "Better\nThan Free\nTransactions":
              'Transações\nMelhores do que\nDe Graça',
          "Make payments globally without any fees.\nEarn rewards when you support\n‘Regenerative’ organizations and people.":
              "Realize pagamentos globalmente sem taxas.\nObtenha recompensas enquanto apoia\npessoas e organizações 'regenerativas'.",
          "Citizen\nCampaigns": 'Campanhas\nde Cidadãos',
          "Participate and vote directly on social and\nenvironmental impact projects you care\nabout.":
              'Participe e vote diretamente em projetos\nde impacto social e ambiental que te\ninteressem.',
          "Regenerative\nEconomy": 'Economia\nRegenerativa',
          "Unite with a global movement of\norganizations and people to regenerate our\nplanet and heal our economy.":
              'Una-se a un movimento global de\norganizações e pessoas para regenerar\nosso planeta e curar nossa economia.',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
