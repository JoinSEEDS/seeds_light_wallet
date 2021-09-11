import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Delete': 'Borrar',
          'Re-enter Pincode': 'Re-ingresar código de acceso',
          'Enter Pincode': 'Ingresar código de acceso',
          'Create Pincode': 'Crear código de acceso',
          'Use biometric to unlock': 'Desbloquear con biometrico',
          'Succesful': 'Completado',
          'Pincode created successfully.': 'Código de acceso creado satisfactoriamente.',
          'Close': 'Cerrar',
          'Pincode does not match': 'El código PIN no coincide',
        },
        'pt_br': {
          'Delete': 'Excluir',
          'Re-enter Pincode': 'Re-digitar código de acesso',
          'Enter Pincode': 'Digite código de acesso',
          'Create Pincode': 'Criar código de acesso',
          'Use biometric to unlock': 'Desbloquear com biometria',
          'Succesful': 'Sucedido',
          'Pincode created successfully.': 'Código de acceso criado com sucesso.',
          'Close': 'Fechar',
          'Pincode does not match': 'O código PIN não coincide',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
