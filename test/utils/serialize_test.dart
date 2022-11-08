import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/crypto/eosdart/src/serialize.dart';

const verbose = false;
void main() {

  group('public keys', () {
    test('serialize k1 old style', ()  {
      final keystring = 'EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPublicKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [0, 2, 192, 222, 210, 188, 31, 19, 5, 251, 15, 170, 197, 230, 192, 62,
            227, 161, 146, 66, 52, 152, 84, 39, 182, 22, 124, 165, 105, 209, 61,
            244, 53, 207]);
    });
    test('serialize k1 new style', ()  {
      final keystring = 'PUB_K1_6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5BoDq63';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPublicKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [0, 2, 192, 222, 210, 188, 31, 19, 5, 251, 15, 170, 197, 230, 192, 62,
            227, 161, 146, 66, 52, 152, 84, 39, 182, 22, 124, 165, 105, 209, 61,
            244, 53, 207]);
    });
    test('deserialize k1 new style', ()  {
      final serialized = Uint8List.fromList([0, 2, 192, 222, 210, 188, 31, 19,
        5, 251, 15, 170, 197, 230, 192, 62, 227, 161, 146, 66, 52, 152, 84, 39,
        182, 22, 124, 165, 105, 209, 61, 244, 53, 207]);
      final sb = new SerialBuffer(serialized);
      final keystring = sb.getPublicKey();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(keystring, 'PUB_K1_6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5BoDq63');
    });
    test('serialize r1 new style', ()  {
      final keystring = 'PUB_R1_6eMzJfDVWvzMTYAUWQ95JcpoY8vFL62pTFm6spim25n5wqtVWP';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPublicKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [1, 2, 231, 80, 174, 4, 190, 33, 189, 1, 48, 165, 223, 203, 242,
           125, 16, 95, 97, 223, 20, 206, 120, 17, 207, 107, 49, 24, 30,
           7, 140, 39, 8, 36]);
    });
    test('deserialize r1 new style', ()  {
      final serialized = Uint8List.fromList(
        [1, 2, 231, 80, 174, 4, 190, 33, 189, 1, 48, 165, 223, 203, 242,
           125, 16, 95, 97, 223, 20, 206, 120, 17, 207, 107, 49, 24, 30,
           7, 140, 39, 8, 36]);
      final sb = new SerialBuffer(serialized);
      final keystring = sb.getPublicKey();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(keystring, 'PUB_R1_6eMzJfDVWvzMTYAUWQ95JcpoY8vFL62pTFm6spim25n5wqtVWP');
    });

  });

  group('private keys', () {
    test('serialize k1 old style', ()  {
      final keystring = '5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPrivateKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [0, 210, 101, 63, 247, 203, 178, 216, 255, 18, 154, 194, 126, 245,
            120, 28, 230, 139, 37, 88, 196, 26, 116, 175, 31, 45, 220, 166, 53,
            203, 238, 240, 125]);
    });
    test('serialize k1 new style', ()  {
      final keystring = 'PVT_K1_2bfGi9rYsXQSXXTvJbDAPhHLQUojjaNLomdm3cEJ1XTzMqUt3V';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPrivateKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [0, 210, 101, 63, 247, 203, 178, 216, 255, 18, 154, 194, 126, 245,
            120, 28, 230, 139, 37, 88, 196, 26, 116, 175, 31, 45, 220, 166, 53,
            203, 238, 240, 125]);
    });
    test('deserialize k1 new style', ()  {
      final serialized = Uint8List.fromList([0, 210, 101, 63, 247, 203, 178,
        216, 255, 18, 154, 194, 126, 245, 120, 28, 230, 139, 37, 88, 196,
        26, 116, 175, 31, 45, 220, 166, 53, 203, 238, 240, 125]);
      final sb = new SerialBuffer(serialized);
      final keystring = sb.getPrivateKey();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(keystring, 'PVT_K1_2bfGi9rYsXQSXXTvJbDAPhHLQUojjaNLomdm3cEJ1XTzMqUt3V');
    });
    test('serialize r1 new style', ()  {
      final keystring = 'PVT_R1_2JrJRQXEagWobhJbHWtP11muTWi5pgCJ6uXWhGKd2KcFBGF7mT';
      final sb = new SerialBuffer(new Uint8List(0));
      sb.pushPrivateKey(keystring);
      final serialized = sb.asUint8List();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(serialized,
          [1, 172, 58, 10, 48, 178, 188, 37, 15, 234, 129, 216, 243, 182,
           68, 115, 41, 18, 206, 91, 223, 230, 199, 84, 66, 41, 110, 159,
           117, 45, 189, 67, 43]);
    });
    test('deserialize r1 new style', ()  {
      final serialized = Uint8List.fromList(
        [1, 172, 58, 10, 48, 178, 188, 37, 15, 234, 129, 216, 243, 182,
           68, 115, 41, 18, 206, 91, 223, 230, 199, 84, 66, 41, 110, 159,
           117, 45, 189, 67, 43]);
      final sb = new SerialBuffer(serialized);
      final keystring = sb.getPrivateKey();

      if(verbose) {
        print("keystring: $keystring");
        print("serialized: $serialized\n"+"   ${arrayToHex(serialized)}");
      }
      expect(keystring, 'PVT_R1_2JrJRQXEagWobhJbHWtP11muTWi5pgCJ6uXWhGKd2KcFBGF7mT');
    });

  });

}
