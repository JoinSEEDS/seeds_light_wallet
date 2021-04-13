

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Select Guardian': 'Seleccionar Guardian',
          'Next': 'Seguir',
          'Choose existing Seeds Member to add as guardians': 'Elija miembros de Seeds para agregar como guardianes',
          'Select up to 5 Guardians to invite': 'Selecciona hasta 5 guardianes para invitar ',
          'Enter user name or account': 'Ingresa nombre de cuenta',
          'Invite Guardians': 'Invitar Guardianes',
          'Send Invite': 'Enviar Invitacion',
          'The users below will be sent an invite to become your Guardian.': 'Los siguientes usuarios recibirán una invitación para convertirse en su Guardian.',
          'Invites Sent!': 'Invitaciones Enviadas',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
