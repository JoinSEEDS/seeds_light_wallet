

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Settings': 'Configuraciónes',
          'Display Name': 'Nombre a mostrar',
          'Set your Display Name so that others can recognize your account.':
              'Configure su nombre a mostrar asi otros pueden reconcer su cuenta.',
          'Bioregion': 'Bioregion',
          'Join or create a bioregion to become active in your local community!':
              '¡Únase o cree una bioregión para participar activamente en su comunidad local!',
          'Currency': 'Moneda',
          'Setting your local currency lets you easily switch between your local and preferred currency.':
              'Configurar su moneda local le permite cambiar fácilmente entre su moneda local y preferida.',
          'Skills & Interest': 'Habilidades e interés',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
