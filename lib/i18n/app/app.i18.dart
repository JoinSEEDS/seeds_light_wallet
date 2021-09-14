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
          "Success, guardians recovery approved":
              "Recuperación de cuenta aprobada",
          "Success, guardians recovery stopped":
              "Recuperación de cuenta detenida",
        },
        'pt_br': {
          'Explore': 'Explorar',
          'Wallet': 'Carteira',
          'Profile': 'Perfil',
          'Cancel Recovery': 'Cancelar Recuperação',
          'Recovery Mode Initiated': 'Modo De Recuperação Iniciado',
          'Someone has initiated the Recovery process for your account. If you did not request to recover your account please select cancel recovery.':
              'Alguém iniciou o processo de recuperação de sua conta. Se não foi você, selecione cancelar recuperação.',
          'Dismiss': 'Fechar',
          'Accept Request': 'Aceitar petição',
          'Account Recovery Request': 'Solicitação de recuperação de conta',
          ' has initiated their account recovery process through their Key Guardians. Accepting this request will help them to recover their account. Please make sure they are who they claim to be and are actually locked out of their account before accepting.':
              ' iniciou seu processo de recuperação de contapor meio de seus Guardiões. Aceitar essa solicitação vai ajudar a recuperar sua conta. Por favor, certifique-se de que eles são quem afirmam ser, e que estão sem acesso à sua conta antes de aceitar.',
          "Oops, something went wrong": "Ops! Algo deu errado",
          "Success, guardians recovery approved":
              "Recuperação de conta aprovada",
          "Success, guardians recovery stopped":
              "Recuperação de conta bloqueada",
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
