import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'No proposals to show, yet': 'No hay propuestas para mostrar, todavía',
          'Error loading proposals': 'Error cargando las Propuestas',
          'Voting cycle ends in': 'Ciclo de voto finaliza en',
          'days': 'días',
          'hrs': 'hrs',
          'mins': 'mins',
          'sec': 'sec',
          'Error loading next moon cycle': 'Error al cargar el próximo ciclo lunar',
          'In favour': 'A favor',
          'Votes': 'votos',
          'Against': 'En contra',
          '+%s voted': '+%s votos',
          '%s voted': '%s votos',
          'alliance': 'Alianza',
          'Campaign': 'Campaña',
          'passed': 'aprobada',
          'rejected': 'rechazada',
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
