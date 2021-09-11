import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Plant': 'Plantar',
          'Plant amount': 'Monto a plantar',
          'Available Balance': 'Balance disponible',
          'Planted Balance': 'Balance de plantadas',
          'Plant Seeds': 'Plantar Seeds',
          'Congratulations\nYour seeds were planted successfully!':
          'Felicitacines\nSus Seeds fueron plantadas exitosamente!',
          'Close': 'Cerrar',
          'Plant failed, try again.': 'Error al plantar, inténte de nuevo',
          'Not enough balance': 'No hay suficiente balance',
          'Error Loading Page': 'Error Cargando La página'
        },
        'pt_br': {
          'Plant': 'Plantar',
          'Plant amount': 'Quantidade para plantar',
          'Available Balance': 'Salto disponível',
          'Planted Balance': 'Saldo plandado',
          'Plant Seeds': 'Plantar Seeds',
          'Congratulations\nYour seeds were planted successfully!':
          'Parabéns\nSeus Seeds foram plantadoss com sucesso!',
          'Close': 'Fechar',
          'Plant failed, try again.': 'Erro ao plantar, tente novamente',
          'Not enough balance': 'Não há saldo suficiente',
          'Error Loading Page': 'Erro Carregando a Página'
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
