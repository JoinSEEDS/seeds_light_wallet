import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      {
        "es_es": {
          "Select Currency": "Selecionar moneda",
          'Search..': "Buscar..",
        },
        "pt_br": {
          "Select Currency": "Selecione a moeda",
          'Search..': "Buscar...",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
