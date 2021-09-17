import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Scan QR Code': 'Escanear código QR',
          "Close": "Cerrar",
          'Invite Code Error': 'Error de código de invitación',
          'This invite code has already been claimed! Please check with the person who invited you.':
              '¡Este código de invitación ya ha sido reclamado! Consulte con la persona que lo invitó.',
          'Processing your invitation...': 'Procesando su invitación...',
          'Success!': 'Éxito!',
          'No invites found, try another code':
              'No se encontró la invitación, intenta otro código',
          'Invite was already claimed': 'La invitación ya se reclamó',
          'Oops, something went wrong. Please try again later.':
              'Ups! Algo salió mal. Por favor, inténtelo de nuevo más tarde.',
          "Note: Usernames must be 12 characters long.\n\n Usernames can only contain characters a-z (all lowercase), 1 - 5 (no 0’s), and no special characters or full stops. \n\n **Reminder! Your account name cannot be changed or deleted and will be public for other users to see.**":
              "Nota: Los nombres de usuario deben tener 12 caracteres.\n\n Los nombres de usuario solo pueden contener caracteres de a-z (todos en minúsculas), 1 - 5 (no 0’s), y sin caracteres especiales ni puntos. \n\n **¡Recordatorio! El nombre de su cuenta no se puede cambiar ni eliminar y será público para que lo vean otros usuarios.** ",
          "Username": 'Nombre De Usuario',
          'Create account': 'Crear cuenta',
          'Failed to create the account. Please try again later.':
              'No se pudo crear la cuenta. Por favor, inténtelo de nuevo más tarde.',
          'The username is already taken.':
              'El nombre de usuario ya está en uso.',
          'Full Name': 'Nombre completo',
          'Name cannot be empty': 'El nombre no puede estar vacío',
          "Enter your full name. You will be able to change this later in your profile settings.":
              'Ingrese su nombre completo. Podrás cambiar esto más tarde en la configuración de tu perfil.',
          'Next': 'Próximo',
        },
        'pt_br': {
          'Scan QR Code': 'Escanear código QR',
          "Close": "Fechar",
          'Invite Code Error': 'Erro de código de convite',
          'This invite code has already been claimed! Please check with the person who invited you.':
              'Este código de convite já foi utilizado! Consulte a pessoa que lhe convidou.',
          'Processing your invitation...': 'Processando seu convite...',
          'Success!': 'Sucesso!',
          'No invites found, try another code':
              'Convite não encontrado, tente outro código',
          'Invite was already claimed': 'O convite já foi usado',
          'Oops, something went wrong. Please try again later.':
              'Ops! Algo deu errado. Por favor, tente mais tarde.',
          "Note: Usernames must be 12 characters long.\n\n Usernames can only contain characters a-z (all lowercase), 1 - 5 (no 0’s), and no special characters or full stops. \n\n **Reminder! Your account name cannot be changed or deleted and will be public for other users to see.**":
              "Nota: Os nomes de usuário precisam ter 12 caracteres.\n\n Os nomes de usuário só podem conter caracteres de a-z (todos em minúsculas), 1-5 (sem 0’s), e sem caracteres especiais nem pontos. \n\n **Lembre-se! O nome de sua conta não pode ser alterado ou excluído e será público para outros usuários verem.** ",
          "Username": 'Nome De Usuário',
          'Create account': 'Criar conta',
          'Failed to create the account. Please try again later.':
              'Falha ao criar a conta. Por favor, tente novamente.',
          'The username is already taken.':
              'Este nome de usuário já está em uso.',
          'Full Name': 'Nome completo',
          'Name cannot be empty': 'O nome não pode estar vazio',
          "Enter your full name. You will be able to change this later in your profile settings.":
              'Digite seu nome completo. Pode alterá-lo mais tarde na configuração de seu perfil.',
          'Next': 'Próximo',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
