import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Onboarding Contract': 'Contrato De Incorporación',
          'Exchange Contract': 'Contrato De Intercambio',
          'Harvest Contract': 'Contrato De Cosecha',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
