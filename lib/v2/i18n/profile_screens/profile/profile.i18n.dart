import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Upgrade To Resident': 'Actualizar A Residente',
          'Upgrade To Citizen': 'Actualizar A Ciudadano',
          "Upgrading account ...": 'Actualizando cuenta ...',
          'Visitor': 'Visitante',
          'Resident': 'Residente',
          'to': 'A',
          'Citizen': 'Ciudadano',
          'You are on the way from': 'Estás en el camino de',
          'View your progress': 'Ver tu progreso',
          'Congratulations!': '¡Felicidades!',
          'You have have fulfilled all the requirements and are now officially upgraded to be a ':
              'Ha cumplido con todos los requisitos y ahora está oficialmente actualizado para ser un',
          ' You now have the ability to vote on proposals! Go to the Explore section to see more.':
              '¡Ahora tiene la posibilidad de votar en las propuestas! Vaya a la sección Explorar para ver más.',
          'Just one more level until you are a full-fledged Citizen.!':
              'Solo un nivel más hasta que seas un Ciudadano!',
          'Done': 'Hecho',
          'Logout': 'Cerrar sesión',
          'Save private key in secure place - to be able to restore access to your wallet later':
              'Guarda la llave privada en un lugar seguro - para poder recuperar acceso a tu billetera luego',
          'Save private key': 'Guarda la llave privada',
          'Security': 'Seguridad',
          'Support': 'Soporte',
          'Contribution Score': 'Puntaje de contribución',
          'Currency': 'Moneda',
          'Choose Picture': 'Escoger foto',
          'Take a picture': 'Tomar foto',
          'Error Loading Page': 'Error Al Cargar Página',
          'Fail to upgrade citizenship status.': 'Fallo al actualizar el estado de ciudadanía.'
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
