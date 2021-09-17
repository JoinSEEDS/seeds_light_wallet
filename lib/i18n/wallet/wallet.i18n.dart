import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          "Balance": 'Saldo',
          'Transactions History': 'Historia de transacciones',
          'Receive': 'Recibir',
          'Send': 'Enviar',
        },
        'pt_br': {
          "Balance": 'Saldo',
          'Transactions History': 'Historico de transações',
          'Receive': 'Receber',
          'Send': 'Enviar',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
