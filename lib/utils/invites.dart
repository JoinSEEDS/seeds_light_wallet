import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:convert/convert.dart';
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

String secretFromMnemonic(String mnemonic) {
  return sha256.convert(utf8.encode(mnemonic)).toString();
}

String hashFromSecret(String secret) {
  return sha256.convert(hex.decode(secret)).toString();
}

String reverseHash(String hash) {
    String firstPart = hash.substring(0, 32);
    String secondPart = hash.substring(32, 64);

    List<String> firstPartChunks = StringUtils.chunk(firstPart, 2);
    List<String> secondPartChunks = StringUtils.chunk(secondPart, 2);

    String firstPartReversed = firstPartChunks.reversed.toList().join('');
    String secondPartReversed = secondPartChunks.reversed.toList().join('');

    String concatenatedReversedHash = "$firstPartReversed$secondPartReversed";

    return concatenatedReversedHash; 
}