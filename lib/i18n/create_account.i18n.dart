

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Please enter your name': 'Por favor ingresa tu nombre',
        'Your account name should have exactly 12 symbols': 'Tu nombre de cuenta debe tener exactamente 12 caracteres',
        'Your account name should only contain numbers 1-5': 'Tu nombre de cuenta puede contener números del 1 al 5',
        "Your account name can't cont'n uppercase letters": 'Tu nombre de cuenta no puede tener letras mayúsculas',
        "Your account name should cont'n lower case letters": 'Tu nombre de cuenta debe tener letras minúsculas',
        'Your name': 'Tu nombre',
        'SEEDS Username': 'SEEDS Nombre de usuario',
        'Full Name': 'Nombre completo',
        'Enter your name': 'Ingresa tu nombre', 
        'Next': 'Siguiente', 
        'Available: ': 'Disponible: ',
        'Create account': 'Crear cuenta',
        
        // NOTE: The sentence "your account should have exactly 12 symbols ..."
        // the words "exactly 12" are bold on the screen
        'Your account name should have ': 'Tu nombre de cuenta debe tener ',
        'exactly 12': 'exactamente 12',
        ' symbols (lowercase letters and digits only 1-5)': ' caracteres (letras minúsculas y números solo del 1 al 5)',
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
