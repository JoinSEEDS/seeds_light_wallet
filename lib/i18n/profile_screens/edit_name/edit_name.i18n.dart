import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Edit Name': 'Editar nombre',
          'Save Changes': 'Guardar cambios',
          'Name': 'Nombre',
          'Please enter a smaller name': 'Ingrese un nombre más pequeño',
        },
        'pt_br': {
          'Edit Name': 'Editar nome',
          'Save Changes': 'Salvar Alterações',
          'Name': 'Nome',
          'Please enter a smaller name': 'Por favor, insira um nome menor',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
