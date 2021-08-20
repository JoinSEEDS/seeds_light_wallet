import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Explore': 'Explorar',
          'Wallet': 'Billetera',
          'Profile': 'Perfil',
          'Cancel Recovery': 'Cancelar Recuperación',
          'Recovery Mode Initiated': 'Modo De Recuperación Iniciado',
          'Someone has initiated the Recovery process for your account. If you did not request to recover your account please select cancel recovery.':
              'Alguien ha iniciado el proceso de recuperación de su cuenta. Si no solicitó recuperar su cuenta, seleccione cancelar recuperación.',
          'Dismiss': 'Descartar',
          'Accept Request': 'Aceptar petición',
          'Account Recovery Request': 'Solicitud de recuperación de cuenta',
          ' has initiated their account recovery process through their Key Guardians. Accepting this request will help them to recover their account. Please make sure they are who they claim to be and are actually locked out of their account before accepting.':
              ' ha iniciado su proceso de recuperación de cuenta a través de sus Guardianes. Aceptar esta solicitud les ayudará a recuperar su cuenta. Por favor, asegúrese de que sean quienes dicen ser y que no tengan acceso a su cuenta antes de aceptar.',
          "Oops, something went wrong": "Ups! Algo salió mal",
          "Success, guardians recovery approved": "Recuperación de cuenta aprobada",
          "Success, guardians recovery stopped": "Recuperación de cuenta detenida",
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
