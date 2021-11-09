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
          'Error loading next moon cycle': 'Error al cargar la siguente luna nueva'
        },
        'pt_br': {
          'Vote': 'Votar',
          'Open': 'Abertas',
          'Upcoming': 'Próximas',
          'History': 'Histórico',
          'No proposals to show, yet': 'Nenhuma proposta para mostrar ainda',
          'Error loading next moon cycle': 'Erro ao carregar a próxima lua nova'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
