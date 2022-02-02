import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:seeds/utils/mnemonic_code/hex.dart';
import 'package:seeds/utils/mnemonic_code/words_list.dart';

/// Taken from Bip39 package
const int _sizeByte = 255;
const _invalidEntropy = 'Invalid entropy';

typedef RandomBytes = Uint8List Function(int size);

int _binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

String _bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join();
}

String _deriveChecksumBits(Uint8List entropy) {
  final ent = entropy.length * 8;
  final cs = ent ~/ 32;
  final hash = sha256.convert(entropy);
  return _bytesToBinary(Uint8List.fromList(hash.bytes)).substring(0, cs);
}

Uint8List randomBytes(int size) {
  final rng = Random.secure();
  final bytes = Uint8List(size);
  for (var i = 0; i < size; i++) {
    bytes[i] = rng.nextInt(_sizeByte);
  }
  return bytes;
}

/// One word is equals to 8 bits of strength, the minumun is 16 (2 words).
/// Default separator dash (-)
String generateMnemonic({int strength = 48, RandomBytes randomBytes = randomBytes}) {
  assert(strength % 16 == 0);
  final Uint8List entropy = randomBytes(strength ~/ 8);
  return entropyToMnemonic(hexCodec.encode(entropy));
}

String entropyToMnemonic(String entropyString) {
  final entropy = Uint8List.fromList(hexCodec.decode(entropyString));
  if (entropy.length < 2) {
    throw ArgumentError("$_invalidEntropy length is ${entropy.length}");
  }
  if (entropy.length > 32) {
    throw ArgumentError("$_invalidEntropy length is ${entropy.length}");
  }
  if (entropy.length % 2 != 0) {
    throw ArgumentError("$_invalidEntropy length is ${entropy.length}");
  }
  final entropyBits = _bytesToBinary(entropy);
  final checksumBits = _deriveChecksumBits(entropy);
  final bits = entropyBits + checksumBits;
  // ignore: unnecessary_raw_strings
  final regex = RegExp(r".{1,11}", caseSensitive: false);
  final chunks = regex.allMatches(bits).map((match) => match.group(0)!).toList(growable: false);
  final List<String> wordlist = wordList;
  final String words = chunks.map((binary) => wordlist[_binaryToByte(binary)]).join('-');
  return words;
}

bool _isSha256Hash(String s) {
  return s.length == 64 && BigInt.tryParse(s, radix: 16) != null;
}

String secretFromMnemonic(String mnemonic) {
  /// mnemonic is either a 12 word string, or it is a hex string that is
  /// already the secret. If it is a hex string, we assume it is a secret and
  /// just return it.
  if (_isSha256Hash(mnemonic)) {
    return mnemonic;
  }
  return sha256.convert(utf8.encode(mnemonic)).toString();
}

String hashFromSecret(String secret) {
  return sha256.convert(hex.decode(secret)).toString();
}
