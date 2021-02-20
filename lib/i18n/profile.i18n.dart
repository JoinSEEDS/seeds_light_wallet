import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Full Name': 'Nombre completo',
          'Enter your name': 'Ingresa tu nombre',
          'Name cannot be empty': 'Nombre no puede estar vacío',
          'Save': 'Guardar',
          'Terms & Conditions': 'Términos y condiciones',
          'Privacy Policy': 'Política de privacidad',
          'Export private key': 'Exportar llave privada',
          'Logout': 'Cerrar sesión',
          'Choose Picture': 'Escoger foto',
          'Take a picture': 'Tomar foto',
          'Profile updated successfully.': 'Perfil actualizado con éxito',
          'An error occured, please try again.':
              'Ocurrió un error, por favor intentar de nuevo',
          'Save private key in secure place - to be able to restore access to your wallet later':
              'Guarda la llave privada en un lugar seguro - para poder recuperar acceso a tu billetera luego',
          'Save private key': 'Guarda la llave privada',
          'Key Guardians': 'Guardianes de Llave',
          // profile_v2
          'Contribution Score': 'Puntaje de contribución',
          'Badges Earned': 'Insignias ganadas',
          'Bioregion': 'Bioregion',
          'Currency': 'Moneda',
          'Skills & Interest': 'Habilidades e interés',
          'You are on the way from': 'Estás en el camino de',
          'Resident': 'Residente',
          'to': 'a',
          'Citizen': 'Ciudadano',
          'View your progress': 'Ver tu progreso',
          'Settings': 'Configuraciones',
          'Security': 'Seguridad',
          'Support': 'Soporte'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
