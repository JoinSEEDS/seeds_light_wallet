import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Invite': 'Invitación',
          'Invite creation failed, try again.': 'Error al crear la invitación, inténte de nuevo',
          'Invite amount': 'Monto de invitación',
          'Available Balance': 'Balance disponible',
          'Create invite': 'Crear invitación',
          'Share this link with the person you want to invite!':
          '¡Comparte este enlace con la persona que quieres invitar!',
          'Share': 'Compartir',
          'Close': 'Cerrar',
          'Not enough balance': 'No hay suficiente balance',
          'Minimum 5 Seeds required to invite': 'Mínimo 5 Seeds requeridas para invitar',
          'Uh oh! Something went wrong...': '¡UH oh! Algo salió mal...',
          'Error loading current balance': 'Error cargando el balance actual'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
