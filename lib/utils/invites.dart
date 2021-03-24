import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:random_words/random_words.dart';

String generateMnemonic({ int words = 5, separator = '-' }) {
  var random = Random.secure();

  var dictionaryWords = 2535;

  var randomDictionaryIndexes = List<int>.generate(
      words, (i) => random.nextInt(dictionaryWords));

  var randomDictionaryWords =
      randomDictionaryIndexes.map((index) => nouns[index]).toList();

  var mnemonic = randomDictionaryWords.join('-');

  return mnemonic;
}

String secretFromMnemonic(String mnemonic) {
  return sha256.convert(utf8.encode(mnemonic)).toString();
}

String hashFromSecret(String secret) {
  return sha256.convert(hex.decode(secret)).toString();
}