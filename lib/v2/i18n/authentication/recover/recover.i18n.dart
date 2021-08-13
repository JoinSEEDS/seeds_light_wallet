import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          "Copied": 'Copiado',
          "Recover Account": 'Recuperar cuenta',
          'Link to Activate Key Guardians': 'Enlace para activar guardianes',
          "Guardians have accepted your request to recover your account":
              'Los guardianes han aceptado su solicitud para recuperar su cuenta.',
          "Cancel Process": 'Cancelar proceso',
          "Claim account": 'Reclamar cuenta',
          "All three of your Key Guardians have accepted your request to recover your account. \n You account will be unlocked in 24hrs. ":
              'Los tres Guardianes han aceptado su solicitud para recuperar su cuenta. \n Su cuenta se desbloqueará en 24 horas.',
          "Hours Left": 'Horas restantes',
          'Account recovered ': 'Cuenta recuperada',
          "Oops, Something went wrong, try again later.": '"Ups! Algo salió mal, por favor trate mas tarde',
          'Next': 'Próximo',
          "Username": 'Nombre de usuario',
          "Error Loading Guardians": "Error al cargar guardianes",
          'Only accounts protected by guardians are accessible for recovery':
              "Solo se puede acceder a las cuentas protegidas por guardiane para su recuperación",
          "Error Loading Account": 'Error al cargar la cuenta',
          'Account is not valid': 'La cuenta no es válida',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
