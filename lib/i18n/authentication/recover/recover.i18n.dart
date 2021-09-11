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
          "There are no guardians for this account.": 'No hay guardianes para esta cuenta.',
          "Oops! Something went wrong, try again later.": 'Ups! Algo salió mal, por favor trate mas tarde.',
          'Next': 'Próximo',
          "Username": 'Nombre de usuario',
          "Error Loading Guardians": "Error al cargar guardianes",
          'Only accounts protected by guardians are accessible for recovery':
              "Solo se puede acceder a las cuentas protegidas por guardiane para su recuperación",
          "Error Loading Account": 'Error al cargar la cuenta',
          'Account is not valid': 'La cuenta no es válida',
        },
        'pt_br': {
          "Copied": 'Copiado',
          "Recover Account": 'Recuperar conta',
          'Link to Activate Key Guardians': 'Link para para ativar guardiões',
          "Guardians have accepted your request to recover your account":
              'Os guardiões aceitaram sua solicitação de repuerar sua conta.',
          "Cancel Process": 'Cancelar processo',
          "Claim account": 'Recuperar conta',
          "All three of your Key Guardians have accepted your request to recover your account. \n You account will be unlocked in 24hrs. ":
              'Todos os três guardiões aceitaram seu pedido de recuperação. \n Sua conta será desbloqueada em 24 horas.',
          "Hours Left": 'Horas restantes',
          'Account recovered ': 'Conta recuperada',
          "There are no guardians for this account.": 'Não há guardiões para essa conta..',
          "Oops! Something went wrong, try again later.": 'Ops! Algo deu errado, por favor tente mais tarde.',
          'Next': 'Próximo',
          "Username": 'Nome de usuario',
          "Error Loading Guardians": "Erro ao carrregar guardiões",
          'Only accounts protected by guardians are accessible for recovery':
              "Somente contas protegidas por guardiões são acessíveis para recuperação",
          "Error Loading Account": 'Erro ao carregar a conta',
          'Account is not valid': 'A conta não é válida',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
