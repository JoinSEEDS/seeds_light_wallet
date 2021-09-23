import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'First time here?': 'Primera vez aqui?',
          'Claim invite code': 'Reclamar codigo de invitacion',
          'Already have a Seeds Account?': 'Ya tienes una cuenta de Seeeds?',
          'Import private key': 'Importar clave privada',
          'Lost your key?': 'Perdiste tu llave?',
          ' Recover ': ' Recuperar ',
          'your account here': 'tu cuenta aqui',
        },
        'pt_br': {
          'First time here?': 'Primeira vez aqui?',
          'Claim invite code': 'Utilizar um codigo de convite',
          'Already have a Seeds Account?': 'Já tem uma conta Seeeds?',
          'Import private key': 'Importar chave privada',
          'Lost your key?': 'Perdeu sua chave?',
          ' Recover ': ' Recuperar ',
          'your account here': 'sua conta aqui',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
