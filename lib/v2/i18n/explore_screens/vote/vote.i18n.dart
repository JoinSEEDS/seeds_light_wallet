import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Vote': 'Votar',
          'Open': 'Abiertas',
          'Upcoming': 'Proximas',
          'History': 'Historial',
          'No proposals to show, yet': 'Aún no hay propuestas para mostrar',
          'Voting cycle ends in': 'Ciclo de voto finaliza en',
          'days': 'días',
          'hrs': 'hrs',
          'mins': 'mins',
          'sec': 'sec',
          'In favour': 'A favor',
          'Votes': 'votos',
          'Against': 'En contra',
          'days left': 'días restantes',
          'View Details and Vote': 'Ver detalles y votar',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
