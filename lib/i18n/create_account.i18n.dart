import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static var _t = Translations.byLocale("en_us") +
    {
      "es_es": {
        'Please enter your name': "Por favor ingresa tu nombre",
        'SEEDS Username': "SEEDS Nombre de usuario",
        'Full Name': "Nombre completo",
        'Enter your name': "Ingresa tu nombre", 
        'Next': "Siguiente", 
        'Available: ': "Disponible: ",
        "Create account": "Crear cuenta",
        
        "Couldn't find a valid account name": "No se pudo encontrar un nombre de cuenta válido",
        "Name can only contain numbers 1..5":"Solo puede contener los números 1..5",
        "Name can be lowercase only": "Solo puede estar en minúsculas",
        "Name can't have space": "Tu nombre no puede tener espacio",
        "Name can't contain @": "Tu nombre no puede contener @",
        "Name can't have special characters":"Tu nombre no puede tener caracteres especiales",
        "Name should have 12 symbols": "Tu nombre debe tener 12 símbolos",
        "Only letters a..z and numbers 1..5": "Solo letras a..z y números 1..5",
        "%s is not available": "%s no está disponible",

        // NOTE: The sentence "your account should have exactly 12 symbols ..."
        // the words "exactly 12" are bold on the screen
        "Your account name should have ": "Tu nombre de cuenta debe tener ",
        "exactly 12": "exactamente 12",
        " symbols (lowercase letters and digits only 1-5)": " caracteres (letras minúsculas y números solo del 1 al 5)",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
