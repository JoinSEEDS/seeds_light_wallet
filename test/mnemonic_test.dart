import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/local/auth_service.dart';

void main() {
  group('mnemonic', () {
    test('Convert words from Seeds Global Passport', () async {
      final mnemonic = "upon what runway husband grief bomb evoke bicycle episode century crystal jazz";
      final expectedPrivateKey = "5HpYGg6hfeD2a16PUoAf22AMzPFUuqDpBCMSbYGRmeDppJ8dyM9";
      final expectedPublicKey = "EOS5DmdNG4mv2tFrJY1yqctExqa34G2anXfaQ5sXeAwZTSnRFVH6Y";

      final authService = AuthService();

      final priv = authService.createPrivateKeyFrom12WordsBip39(mnemonic.split(' '));

      print("Prive: ${priv.toString()}");

      expect(priv.toString(), expectedPrivateKey);
    });
  });
}
