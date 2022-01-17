import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/local/auth_service.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

void main() {
  group('mnemonic', () {
    test('decode mnemonic', () async {
      final mnemonic = generateMnemonic();

      final secret = secretFromMnemonic(mnemonic);

      final secret2 = secretFromMnemonic(secret);

      print("mnemonic: $mnemonic");
      print("secret: $secret");
      print("secret2: $secret2");

      expect(secret, secret2);
    });
  });

  group('Seeds Global Passport Mnemonic', () {
    test('Convert words from Seeds Global Passport', () async {
      final mnemonic = "upon what runway husband grief bomb evoke bicycle episode century crystal jazz";
      final expectedPrivateKey = "5HpYGg6hfeD2a16PUoAf22AMzPFUuqDpBCMSbYGRmeDppJ8dyM9";
      final expectedPublicKey = "EOS5DmdNG4mv2tFrJY1yqctExqa34G2anXfaQ5sXeAwZTSnRFVH6Y";

      final authService = AuthService();

      final eosKey = authService.createPrivateKeyFrom12WordsBip39(mnemonic.split(' '));

      expect(eosKey.toString(), expectedPrivateKey);
      expect(eosKey.toEOSPublicKey().toString(), expectedPublicKey);
    });
  });
}
