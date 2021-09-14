import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          "Security": "Seguridad",
          'Export Private Key': "Exportar llave privada",
          'Export your private key so you can easily recover and access your account.':
              "Exporte su clave privada para que pueda recuperar y acceder fácilmente a su cuenta.",
          'Secure with Pin': "Asegurar con Pin",
          'Secure your account with a 6-digit pincode':
              "Asegure su cuenta con un código PIN de 6 dígitos",
          'Secure with Touch/Face ID': "Seguro con Touch / Face ID",
          "Secure your account with your fingerprint. This will be used to sign-in and open your wallet.":
              "Asegure su cuenta con su huella digital. Esto se utilizará para iniciar sesión y abrir su billetera.",
          'Got it, thanks!': 'Entendido, gracias!',
          'Touch ID/ Face ID': 'Identifición de Toque/ Identifición de Rostro',
          'When Touch ID/Face ID has been set up, any biometric saved in your device will be able to login into the Seeds Light Wallet. You will not be able to use this feature for transactions.':
              "Cuando se haya configurado Identifición de Toque/ Identifición de Rostro, cualquier biométrico guardado en su dispositivo podrá iniciar sesión en Seeds Light Wallet. No podrá utilizar esta función para transacciones.",
          "Active": 'Activo',
          'Inactive': 'Inactivo',
          'Ready To Activate': 'Listo Para Activar',
          'Key Guardians': "Guardianes De LLave",
          'Choose 3 - 5 friends and/or family members to help you recover your account in case.':
              "Elija de 3 a 5 amigos y/ o familiares para ayudarlo a recuperar su cuenta en caso de que lo necesite.",
        },
        'pt_br': {
          "Security": "Segurança",
          'Export Private Key': "Exportar chave privada",
          'Export your private key so you can easily recover and access your account.':
              "Exporte sua chave privada para poder recuperar e acessar facilmente sua conta.",
          'Secure with Pin': "Aumentar a segurança com Pin",
          'Secure your account with a 6-digit pincode':
              "Aumente a segurança da sua conta com um código PIN de 6 dígitos",
          'Secure with Touch/Face ID':
              "Aumentar a segurança com Touch / Face ID",
          "Secure your account with your fingerprint. This will be used to sign-in and open your wallet.":
              "Aumente a segurança de sua conta com biometria. Esse formato será usado para destravar sua carteira.",
          'Got it, thanks!': 'Entendido, obrigado!',
          'Touch ID/ Face ID': 'Identificação de Face / Impressão Digital',
          'When Touch ID/Face ID has been set up, any biometric saved in your device will be able to login into the Seeds Light Wallet. You will not be able to use this feature for transactions.':
              "Quando a identificação por Face / Impressão Digital for ativada, qualquer registro biométrico desse tipo pode ser usado para destravar sua Seeds Light Wallet. Não poderá usar esse recurso para transações.",
          "Active": 'Ativo',
          'Inactive': 'Inativo',
          'Ready To Activate': 'Pronto para Ativar',
          'Key Guardians': "Guardiões de Chave",
          'Choose 3 - 5 friends and/or family members to help you recover your account in case.':
              "Escolha de 3 a 5 amigos ou familiares para lhe ajudar a recuperar sua conta caso seja necessário.",
        }
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
