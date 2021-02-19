import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'You can ask for an invite at': 'Puedes solicitar una invitación en',
        'Membership based on Web of Trust': 'Membresía basada en una Red de Confianza',
        'By signing up, you agree to our terms and privacy policy': 'Al registrarte, aceptas nuestros términos y política de privacidad',
        'Terms & Conditions': 'Términos y condiciones',
        'Privacy Policy': 'Política de privacidad',
        'If you have an account\nclick here': 'Si tienes cuenta\ntoca aquí',
        'Import private key': 'Importar llave privada',
        'If you have an invite\nclick here': 'Si tienes invitación\ntoca aquí',
        'Claim invite code': 'Reclama código de invitación',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
