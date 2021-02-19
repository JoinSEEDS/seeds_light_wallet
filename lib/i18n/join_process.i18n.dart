import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
         'Initialize new wallet...': 'Inicializar billetera nueva...',
          'Process invite link...': 'Procesar enlace de invitación...',
          'Accept invite from %s...': 'Aceptar invitación de %s...',

          // Example:
          // "Create account testact11111"
          'Create account %s...': 'Crear cuenta %s...',
          'Import account %s...': 'Importar cuenta %s...',
          'Secure wallet %s...': 'Asegurar billetera %s...',

      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
