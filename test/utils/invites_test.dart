import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/utils/invites.dart';

void main() {

  group('Invites', () {

    test('Generate 5 word mnemonic', () async {
      final result = generateMnemonic();

      expect(result.split("-").length, 5);
    });

    test('Secret from mnemonic', () async {
      final result = secretFromMnemonic("word1-word2-word3-word4-word5");

      expect(result, "34428fab184f30bfd02d3f93e51704831fe5c1a5f9c7546b62d1b593e85c3cea");
    });

    test('Hash from mnemonic secret', () async {
      final result = hashFromSecret("34428fab184f30bfd02d3f93e51704831fe5c1a5f9c7546b62d1b593e85c3cea");

      expect(result, "dc548a2cc50055fb46d7f3f475366b9fda686dadae02f6f14256065a88ccb58f");
    });

    test('Reverse hash', () async {
      final result = reverseHash("dc548a2cc50055fb46d7f3f475366b9fda686dadae02f6f14256065a88ccb58f");

      expect(result, "9f6b3675f4f3d746fb5500c52c8a54dc8fb5cc885a065642f1f602aead6d68da");
    });

  });


}