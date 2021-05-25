import 'dart:math';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' show sha256;
import 'hex.dart';
import 'words_list.dart';

/// Taken from Bip39 package

const int _SIZE_BYTE = 255;
typedef RandomBytes = Uint8List Function(int size);
const _INVALID_ENTROPY = 'Invalid entropy';

int _binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

String _bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
}

String _deriveChecksumBits(Uint8List entropy) {
  final ent = entropy.length * 8;
  final cs = ent ~/ 32;
  final hash = sha256.convert(entropy);
  return _bytesToBinary(Uint8List.fromList(hash.bytes)).substring(0, cs);
}

Uint8List _randomBytes(int size) {
  final rng = Random.secure();
  final bytes = Uint8List(size);
  for (var i = 0; i < size; i++) {
    bytes[i] = rng.nextInt(_SIZE_BYTE);
  }
  return bytes;
}

/// One word is equals to 8 bits of strength, the minumun is 16 (2 words).
/// Default separator dash (-)
String generateMnemonic({int strength = 48, RandomBytes randomBytes = _randomBytes}) {
  assert(strength % 16 == 0);
  final entropy = randomBytes(strength ~/ 8);
  return entropyToMnemonic(HEX.encode(entropy));
}

String entropyToMnemonic(String entropyString) {
  final entropy = Uint8List.fromList(HEX.decode(entropyString));
  if (entropy.length < 2) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  if (entropy.length > 32) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  if (entropy.length % 2 != 0) {
    throw ArgumentError(_INVALID_ENTROPY);
  }
  final entropyBits = _bytesToBinary(entropy);
  final checksumBits = _deriveChecksumBits(entropy);
  final bits = entropyBits + checksumBits;
  final regex = RegExp(r".{1,11}", caseSensitive: false, multiLine: false);
  final chunks = regex.allMatches(bits).map((match) => match.group(0)!).toList(growable: false);
  List<String> wordlist = WORDLIST;
  String words = chunks.map((binary) => wordlist[_binaryToByte(binary)]).join('-');
  return words;
}

String secretFromMnemonic(String mnemonic) {
  return sha256.convert(utf8.encode(mnemonic)).toString();
}

String hashFromSecret(String secret) {
  return sha256.convert(hex.decode(secret)).toString();
}
