// @dart=2.9

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        
        'Invites': 'Invitaciones',
        'Members invited by you:': 'Miembros invitados por ti',
        'Active invites:': 'Invitaciones activas',
        '%s (copy)': '%s (copia)', // copy tx hash
        'Sow: %s': 'Siembra: %s',
        'Transfer: %s': 'Transfiere: %s',
        'No active invites': 'No hay invitaciones activas',
        'Create new invite': 'Crear nueva invitación',

        'Transaction hash: %s': 'Hash de transacción: %s',
        'Show invite code': 'Mostrar código de invitación',
        'Invite friend': 'Invitar amiga(o)',
        'Invite amount (minimum: 5)': 'Monto de invitación (mínimo: 5)',
        'Create invite': 'Crear invitación',
        'GREAT': 'GENIAL',
        'Share this link with the person you want to invite!': '¡Comparte este enlace con la persona que quieres invitar!',
        'Share Link': 'Comparte enlace',
        'Share Code': 'Comparte código',
        'Done': 'Listo',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
