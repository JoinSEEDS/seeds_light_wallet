import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Invite': 'Invitación',
          'Invite creation failed, try again.':
              'Error al crear la invitación, inténte de nuevo',
          'Invite amount': 'Monto de invitación',
          'Available Balance': 'Balance disponible',
          'Create invite': 'Crear invitación',
          'Share this link with the person you want to invite!':
              '¡Comparte este enlace con la persona que quieres invitar!',
          'Share': 'Compartir',
          'Close': 'Cerrar',
          'Not enough balance': 'No hay suficiente balance',
          'Minimum 5 Seeds required to invite':
              'Mínimo 5 Seeds requeridas para invitar',
          'Uh oh! Something went wrong...': '¡UH oh! Algo salió mal...',
          'Error loading current balance': 'Error cargando el balance actual'
        },
        'pt_br': {
          'Invite': 'Convidar',
          'Invite creation failed, try again.':
              'Erro ao criar o convite, tente novamente.',
          'Invite amount': 'Quantidade para enviar',
          'Available Balance': 'Saldo disponível',
          'Create invite': 'Criar convite',
          'Share this link with the person you want to invite!':
              'Compartinhe esse link com a pessoa que quer convidar!',
          'Share': 'Compartilhar',
          'Close': 'Fechar',
          'Not enough balance': 'Não há saldo suficiente',
          'Minimum 5 Seeds required to invite':
              'Mínimo de 5 Seeds requeridos para convidar',
          'Uh oh! Something went wrong...': 'Ops! Algo deu errado...',
          'Error loading current balance': 'Erro carregando o saldo atual'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
