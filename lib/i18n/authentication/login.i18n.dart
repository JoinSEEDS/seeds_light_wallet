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
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
