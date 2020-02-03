import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:random_words/random_words.dart';

String generateMnemonic({ int words = 5, separator = '-' }) {
  var random = Random.secure();

  int dictionaryWords = 2535;

  var randomDictionaryIndexes = List<int>.generate(
      words, (i) => random.nextInt(dictionaryWords));

  List<String> randomDictionaryWords =
      randomDictionaryIndexes.map((index) => nouns[index]).toList();

  String mnemonic = randomDictionaryWords.join('-');

  return mnemonic;
}

String convertHash(String data) {
  return sha256.convert(utf8.encode(data)).toString();
}