// @dart=2.9

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Accept your invite to create a new account and join SEEDS': 
        'Acepta tu invitación a crear una nueva cuenta y únete a SEEDS',
        'You are invited by %s': 'Has sido invitado por %s',
        'ACCEPT': 'ACEPTAR',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
