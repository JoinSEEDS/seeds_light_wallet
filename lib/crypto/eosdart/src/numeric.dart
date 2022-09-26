// ignore_for_file: type_annotate_public_apis, non_constant_identifier_names, prefer_final_locals, parameter_assignments, unnecessary_new, prefer_interpolation_to_compose_strings, prefer_final_in_for_each, avoid_escaping_inner_quotes, always_declare_return_types

import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart';

/// @module Numeric

var base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
var base64Chars =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

List<int> create_base58_map() {
  var base58M = List.filled(256, -1);
  for (var i = 0; i < base58Chars.length; ++i) {
    base58M[base58Chars.codeUnitAt(i)] = i;
  }
  return base58M;
}

final base58Map = create_base58_map();

List<int> create_base64_map() {
  var base64M = List.filled(256, -1);
  for (var i = 0; i < base64Chars.length; ++i) {
    base64M[base64Chars.codeUnitAt(i)] = i;
  }
  base64M['='.codeUnitAt(0)] = 0;
  return base64M;
}

final base64Map = create_base64_map();

/// Is `bignum` a negative number?
bool isNegative(Uint8List bignum) {
  return (bignum[bignum.length - 1] & 0x80) != 0;
}

/// Negate `bignum`
void negate(Uint8List bignum) {
  var carry = 1;
  for (var i = 0; i < bignum.length; ++i) {
    var x = (~bignum[i] & 0xff) + carry;
    bignum[i] = x;
    carry = x >> 8;
  }
}

/// Convert an unsigned decimal number in `s` to a bignum
/// @param size bignum size (bytes)
Uint8List decimalToBinary(int size, String s) {
  var result = Uint8List(size);
  for (var i = 0; i < s.length; ++i) {
    var srcDigit = s.codeUnitAt(i);
    if (srcDigit < '0'.codeUnitAt(0) || srcDigit > '9'.codeUnitAt(0)) {
      throw 'invalid number';
    }
    var carry = srcDigit - '0'.codeUnitAt(0);
    for (var j = 0; j < size; ++j) {
      var x = result[j] * 10 + carry;
      result[j] = x;
      carry = x >> 8;
    }
    if (carry != 0) {
      throw 'number is out of range';
    }
  }
  return result;
}

/// Convert a signed decimal number in `s` to a bignum
/// @param size bignum size (bytes)
Uint8List signedDecimalToBinary(int size, String s) {
  var negative = s[0] == '-';
  if (negative) {
    s = s.substring(1);
  }
  var result = decimalToBinary(size, s);
  if (negative) {
    negate(result);
    if (!isNegative(result)) {
      throw 'number is out of range';
    }
  } else if (isNegative(result)) {
    throw 'number is out of range';
  }
  return result;
}

/// Convert `bignum` to an unsigned decimal number
/// @param minDigits 0-pad result to this many digits
String binaryToDecimal(Uint8List bignum, {minDigits = 1}) {
  var result = List.filled(minDigits, '0'.codeUnitAt(0), growable: true);
  for (var i = bignum.length - 1; i >= 0; --i) {
    var carry = bignum[i];
    for (var j = 0; j < result.length; ++j) {
      var x = ((result[j] - '0'.codeUnitAt(0)) << 8) + carry;
      result[j] = '0'.codeUnitAt(0) + x % 10;
      carry = (x ~/ 10) | 0;
    }
    while (carry != 0) {
      result.add('0'.codeUnitAt(0) + carry % 10);
      carry = (carry ~/ 10) | 0;
    }
  }
  return String.fromCharCodes(result.reversed.toList());
}

/// Convert `bignum` to a signed decimal number
/// @param minDigits 0-pad result to this many digits
String signedBinaryToDecimal(Uint8List bignum, {int minDigits = 1}) {
  if (isNegative(bignum)) {
    var x = bignum.getRange(0, 0) as Uint8List;
    negate(x);
    return '-' + binaryToDecimal(x, minDigits: minDigits);
  }
  return binaryToDecimal(bignum, minDigits: minDigits);
}

/// Convert an unsigned base-58 number in `s` to a bignum
/// @param size bignum size (bytes)
Uint8List base58ToBinary(int size, String s) {
  var result = new Uint8List(size);
  for (var i = 0; i < s.length; ++i) {
    var carry = base58Map[s.codeUnitAt(i)];
    if (carry < 0) {
      throw 'invalid base-58 value';
    }
    for (var j = 0; j < size; ++j) {
      var x = result[j] * 58 + carry;
      result[j] = x;
      carry = x >> 8;
    }
    if (carry != 0) {
      throw 'base-58 value is out of range';
    }
  }
  return Uint8List.fromList(result.reversed.toList());
}

/// Convert `bignum` to a base-58 number
/// @param minDigits 0-pad result to this many digits
String binaryToBase58(Uint8List bignum, {minDigits = 1}) {
  var result = <int>[];
  for (var byte in bignum) {
    var carry = byte;
    for (var j = 0; j < result.length; ++j) {
      var x = (base58Map[result[j]] << 8) + carry;
      result[j] = base58Chars.codeUnitAt(x % 58);
      carry = (x ~/ 58) | 0;
    }
    while (carry != 0) {
      result.add(base58Chars.codeUnitAt(carry % 58));
      carry = (carry ~/ 58) | 0;
    }
  }
  for (var byte in bignum) {
    if (byte != 0) {
      break;
    } else {
      result.add('1'.codeUnitAt(0));
    }
  }
  return String.fromCharCodes(result.reversed.toList());
}

/// Convert an unsigned base-64 number in `s` to a bignum
Uint8List base64ToBinary(String s) {
  var len = s.length;
  if ((len & 3) == 1 && s[len - 1] == '=') {
    len -= 1;
  } // fc appends an extra '='
  if ((len & 3) != 0) {
    throw 'base-64 value is not padded correctly';
  }
  var groups = len >> 2;
  var bytes = groups * 3;
  if (len > 0 && s[len - 1] == '=') {
    if (s[len - 2] == '=') {
      bytes -= 2;
    } else {
      bytes -= 1;
    }
  }
  var result = new Uint8List(bytes);

  for (var group = 0; group < groups; ++group) {
    var digit0 = base64Map[s.codeUnitAt(group * 4 + 0)];
    var digit1 = base64Map[s.codeUnitAt(group * 4 + 1)];
    var digit2 = base64Map[s.codeUnitAt(group * 4 + 2)];
    var digit3 = base64Map[s.codeUnitAt(group * 4 + 3)];
    result[group * 3 + 0] = (digit0 << 2) | (digit1 >> 4);
    if (group * 3 + 1 < bytes) {
      result[group * 3 + 1] = ((digit1 & 15) << 4) | (digit2 >> 2);
    }
    if (group * 3 + 2 < bytes) {
      result[group * 3 + 2] = ((digit2 & 3) << 6) | digit3;
    }
  }
  return result;
}

/// Key types this library supports */
enum KeyType {
  k1,
  r1,
}

/// Public key data size, excluding type field
var publicKeyDataSize = 33;

/// Private key data size, excluding type field
var privateKeyDataSize = 32;

/// Signature data size, excluding type field
var signatureDataSize = 65;

/// Public key, private key, or signature in binary form
class IKey {
  KeyType type;
  Uint8List data;

  IKey(this.type, this.data);
}

Uint8List digestSuffixRipemd160(Uint8List data, String suffix) {
  var d = new Uint8List(data.length + suffix.length);
  for (var i = 0; i < data.length; ++i) {
    d[i] = data[i];
  }
  for (var i = 0; i < suffix.length; ++i) {
    d[data.length + i] = suffix.codeUnitAt(i);
  }
  var dg = Digest("RIPEMD-160");
  return dg.process(d);
}

IKey stringToKey(String s, KeyType type, int size, String suffix) {
  var whole = base58ToBinary(size + 4, s);
  var result = IKey(type, whole.sublist(0,size));
  var digest = digestSuffixRipemd160(result.data, suffix).toList();
  if (digest[0] != whole[size + 0] ||
      digest[1] != whole[size + 1] ||
      digest[2] != whole[size + 2] ||
      digest[3] != whole[size + 3]) {
    throw 'checksum doesn\'t match';
  }
  return result;
}

String keyToString(IKey key, String suffix, String prefix) {
  var digest = digestSuffixRipemd160(key.data, suffix);
  var whole = Uint8List(key.data.length + 4);
  for (var i = 0; i < key.data.length; ++i) {
    whole[i] = key.data[i];
  }
  for (var i = 0; i < 4; ++i) {
    whole[i + key.data.length] = digest[i];
  }
  return prefix + binaryToBase58(whole);
}

/// Convert key in `s` to binary form
IKey stringToPublicKey(String s) {
  if (s.substring(0, 3) == 'EOS') {
    var whole = base58ToBinary(publicKeyDataSize + 4, s.substring(3));
    var key = IKey(KeyType.k1, new Uint8List(publicKeyDataSize));
    for (var i = 0; i < publicKeyDataSize; ++i) {
      key.data[i] = whole[i];
    }
    var dg = Digest("RIPEMD-160");
    var digest = dg.process(key.data);
    if (digest[0] != whole[publicKeyDataSize] ||
        digest[1] != whole[34] ||
        digest[2] != whole[35] ||
        digest[3] != whole[36]) {
      throw 'checksum doesn\'t match';
    }
    return key;
  } else if (s.substring(0, 7) == 'PUB_K1_') {
    return stringToKey(s.substring(7), KeyType.k1, publicKeyDataSize, 'K1');
  } else if (s.substring(0, 7) == 'PUB_R1_') {
    return stringToKey(s.substring(7), KeyType.r1, publicKeyDataSize, 'R1');
  } else {
    throw 'unrecognized public key format';
  }
}

/// Convert `key` to string (base-58) form
publicKeyToString(IKey key) {
  if (key.type == KeyType.k1 && key.data.length == publicKeyDataSize) {
    return keyToString(key, 'K1', 'PUB_K1_');
  } else if (key.type == KeyType.r1 && key.data.length == publicKeyDataSize) {
    return keyToString(key, 'R1', 'PUB_R1_');
  } else {
    throw 'unrecognized public key format';
  }
}

/// If a key is in the legacy format (`EOS` prefix), then convert it to the new format (`PUB_K1_`).
/// Leaves other formats untouched
String convertLegacyPublicKey(String s) {
  if (s.substring(0, 3) == 'EOS') {
    return publicKeyToString(stringToPublicKey(s));
  }
  return s;
}

/// If a key is in the legacy format (`EOS` prefix), then convert it to the new format (`PUB_K1_`).
/// Leaves other formats untouched
List<String> convertLegacyPublicKeys(List<String> keys) =>
    keys.map((item) => convertLegacyPublicKey(item)).toList();

/// Convert key in `s` to binary form
IKey stringToPrivateKey(String s) {
  if (s.substring(0, 7) == 'PVT_R1_') {
    return stringToKey(s.substring(7), KeyType.r1, privateKeyDataSize, 'R1');
  } else {
    throw 'unrecognized private key format';
  }
}

/// Convert `key` to string (base-58) form */
String privateKeyToString(IKey key) {
  if (key.type == KeyType.r1) {
    return keyToString(key, 'R1', 'PVT_R1_');
  } else {
    throw 'unrecognized private key format';
  }
}

/// Convert key in `s` to binary form */
IKey stringToSignature(String s) {
  if (s.substring(0, 7) == 'SIG_K1_') {
    return stringToKey(s.substring(7), KeyType.k1, signatureDataSize, 'K1');
  } else if (s.substring(0, 7) == 'SIG_R1_') {
    return stringToKey(s.substring(7), KeyType.r1, signatureDataSize, 'R1');
  } else {
    throw 'unrecognized signature format';
  }
}

/// Convert `signature` to string (base-58) form */
String signatureToString(IKey signature) {
  if (signature.type == KeyType.k1) {
    return keyToString(signature, 'K1', 'SIG_K1_');
  } else if (signature.type == KeyType.r1) {
    return keyToString(signature, 'R1', 'SIG_R1_');
  } else {
    throw 'unrecognized signature format';
  }
}
