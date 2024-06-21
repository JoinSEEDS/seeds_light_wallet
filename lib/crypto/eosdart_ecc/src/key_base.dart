// ignore_for_file: directives_ordering, implementation_imports, duplicate_ignore, non_constant_identifier_names, prefer_final_locals, flutter_style_todos

import 'dart:typed_data';
import 'dart:convert';

import 'package:bs58check/bs58check.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import "package:pointycastle/ecc/curves/secp256k1.dart";
import 'package:seeds/crypto/eosdart_ecc/src/big_int_encoder.dart';

// ignore: always_use_package_imports
import './exception.dart';

/// abstract EOS Key
abstract class EOSKey {
  static final String SHA256X2 = 'sha256x2';
  static final int VERSION = 0x80;
  static final ECCurve_secp256k1 secp256k1 = ECCurve_secp256k1();

  String? keyType;

  /// Decode key from string format
  static Uint8List decodeKey(String keyStr, [String? keyType]) {
    Uint8List buffer = base58.decode(keyStr);

    Uint8List checksum = buffer.sublist(buffer.length - 4, buffer.length);
    Uint8List key = buffer.sublist(0, buffer.length - 4);

    Uint8List newChecksum;
    if (keyType == SHA256X2) {
      newChecksum = sha256x2(key).sublist(0, 4);
    } else {
      Uint8List check = key;
      if (keyType != null) {
        check = concat(key, utf8.encode(keyType));
      }
      newChecksum = RIPEMD160Digest().process(check).sublist(0, 4);
    }
    if (decodeBigInt(checksum) != decodeBigInt(newChecksum)) {
      throw InvalidKey("checksum error");
    }
    return key;
  }

  /// Encode key to string format using base58 encoding
  static String encodeKey(Uint8List key, [String? keyType]) {
    if (keyType == SHA256X2) {
      Uint8List checksum = sha256x2(key).sublist(0, 4);
      return base58.encode(concat(key, checksum));
    }

    Uint8List keyBuffer = key;
    if (keyType != null) {
      keyBuffer = concat(key, utf8.encode(keyType));
    }
    Uint8List checksum = RIPEMD160Digest().process(keyBuffer).sublist(0, 4);
    return base58.encode(concat(key, checksum));
  }

  /// Do SHA256 hash twice on the given data
  static Uint8List sha256x2(Uint8List data) {
    Digest d1 = sha256.convert(data);
    Digest d2 = sha256.convert(d1.bytes);
    return d2.bytes as Uint8List;
  }

  static Uint8List concat(Uint8List p1, Uint8List p2) {
    List<int> keyList = p1.toList();
    keyList.addAll(p2);
    return Uint8List.fromList(keyList);
  }

  static List<int> toSigned(Uint8List bytes) {
    List<int> result = [];
    for (int i = 0; i < bytes.length; i++) {
      int v = bytes[i].toSigned(8);
      //TODO I don't know why, just guess...
      if (i == 0 && v < 0) {
        result.add(0);
      }
      result.add(v);
    }
    return result;
  }
}
