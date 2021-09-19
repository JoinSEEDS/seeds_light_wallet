import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Private Key': 'Llave Privada',
          'Private Key cannot be empty': 'Llave privada no puede estar vacía',
          'If you already have a Seeds account, please enter your private key and your account will be imported automatically.':
              'Si ya tienes una cuenta de Seeds, por favor, ingresa tu llave privada activa y tu cuenta se importará automáticamente.',
          'Search': 'Buscar',
          'Private key is not valid': 'Llave privada no es válida',
          'No accounts found': 'No se encontraron cuentas',
          'Error Loading Accounts': 'Error al cargar cuentas',
        },
        'pt_br': {
          'Private Key': 'Chave Privada',
          'Private Key cannot be empty': 'A chave privada não pode estar vazia',
          'If you already have a Seeds account, please enter your private key and your account will be imported automatically.':
              'Se você já tem uma conta Seeds, por favor, digite sua chave privada e sua conta será importada automaticamente.',
          'Search': 'Buscar',
          'Private key is not valid': 'A chave privada não é válida',
          'No accounts found': 'Nenhuma conta encontrada',
          'Error Loading Accounts': 'Erro ao carregar contas',
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
