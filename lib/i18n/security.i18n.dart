import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      {
        "es_es": {
          "Security": "Seguridad",
          'Touch ID/ Face ID': "Touch ID/ Face ID",
          'When Touch ID/Face ID has been set up, any biometric saved in your device will be able to login into the Seeds Light Wallet. You will not be able to use this feature for transactions.':
              "Cuando se haya configurado Touch ID / Face ID, cualquier biométrico guardado en su dispositivo podrá iniciar sesión en Seeds Light Wallet. No podrá utilizar esta función para transacciones.",
          'Got it, thanks!': 'Entendido, gracias!',
          'Export Private Key': "Exportar llave privada",
          'Export your private key so you can easily recover and access your account.':
              "Exporte su clave privada para que pueda recuperar y acceder fácilmente a su cuenta.",
          'Key Guardians': "Key Guardians",
          'Choose 3 - 5 friends and/or family members to help you recover your account in case.':
              "Elija de 3 a 5 amigos y / o familiares para ayudarlo a recuperar su cuenta en caso de que lo necesite.",
          'Secure with Pin': "Asegurar con Pin",
          'Secure your account with a 6-digit pincode': "Asegure su cuenta con un código PIN de 6 dígitos",
          'Secure with Touch/Face ID': "Seguro con Touch / Face ID",
          "Secure your account with your fingerprint. This will be used to sign-in and open your wallet.":
              "Asegure su cuenta con su huella digital. Esto se utilizará para iniciar sesión y abrir su billetera."
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
