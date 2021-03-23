import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Edit Display Name': 'Editar nombre a mostrar',
          'Save Changes': 'Guardar cambios',
          'Display name': 'Nombre a mostrar',
          'Please enter a smaller name, maximum 42 characters': 'Ingrese un nombre más pequeño, máximo 42 caracteres',
        },
        'id_id': {
          'Edit Display Name': 'Edit Nama Tampilan',
          'Save Changes': 'Simpan Perubahan',
          'Display name': 'Nama tampilan',
          'Please enter a smaller name, maximum 42 characters': 'Harap masukkan nama yang lebih kecil',
        }

      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
