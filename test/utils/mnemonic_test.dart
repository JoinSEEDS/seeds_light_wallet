import 'package:flutter_test/flutter_test.dart';
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
}
