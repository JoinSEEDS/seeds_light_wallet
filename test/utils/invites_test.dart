import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/utils/invites.dart';

void main() {

  group('Invites', () {

    test('Generate 5 word mnemonic', () async {
      final result = generateMnemonic();

      expect(result.split("-").length, 5);
    });

    test('Secret from mnemonic', () async {
      final result = secretFromMnemonic("founder-judgment-mate-menu-harassment");

      expect(result, "0e1db5f717be39fe62405ad3ec64e628e44e0d671e7ddb8a7beb2c35a8caa1b8");
    });

    test('Hash from mnemonic secret', () async {
      final result = hashFromSecret("0e1db5f717be39fe62405ad3ec64e628e44e0d671e7ddb8a7beb2c35a8caa1b8");

      expect(result, "23b96581f3d5c10973904cf1b0dbca23cafdd7425852be0ca664ce17ae98bcd5");
    });

    test('Reverse hash', () async {
      final result = reverseHash("dc548a2cc50055fb46d7f3f475366b9fda686dadae02f6f14256065a88ccb58f");

      expect(result, "9f6b3675f4f3d746fb5500c52c8a54dc8fb5cc885a065642f1f602aead6d68da");
    });

  });


}