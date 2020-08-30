import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        "Proposals - Vote": "Propuestas - Votar",
        "Tap to participate": "Toca para participar",
        "Trust Tokens": "Tokens de Confianza",

        "Invite": "Invitar",
        "Tap to send an invite": "Toca para enviar invitación",
        "Available Seeds": "Seeds disponibles",
        
        "Harvest - Plant": "Cosecha - Planta",
        "Tap to plant Seeds": "Toca para plantar Seeds",
        "Planted Seeds": "Seeds plantadas",

        "Sow: %s Transfer: %s": "Siembra: %s Transfiere: %s",
        "Copy": "Copiar",
        "Cancel": "Cancelar",
        "Your invites": "Tus invitaciones",
        "Build community - gain reputation": "Construye comunidad - gana reputación",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
