part of 'import_key_bloc.dart';

abstract class ImportKeyEvent extends Equatable {
  const ImportKeyEvent();

  @override
  List<Object?> get props => [];
}

class FindAccountByKey extends ImportKeyEvent {
  final String privateKey;
  final String? alternatePrivateKey;
  final List<String> words;

  const FindAccountByKey({required this.privateKey, this.alternatePrivateKey, required this.words});

  @override
  String toString() => 'FindAccountByKey';
}

class AccountSelected extends ImportKeyEvent {
  final String account;

  const AccountSelected({required this.account});

  @override
  String toString() => 'AccountSelected: { account: $account }';
}

class OnPrivateKeyChange extends ImportKeyEvent {
  final String privateKeyChanged;

  const OnPrivateKeyChange({required this.privateKeyChanged});

  @override
  String toString() => 'OnPrivateKeyChange: { inputChange: $privateKeyChanged }';
}

class OnWordChange extends ImportKeyEvent {
  final String word;
  final int wordIndex;

  const OnWordChange({required this.word, required this.wordIndex});

  @override
  String toString() => 'OnWordChange: { word: $word index: $wordIndex}';
}

class FindAccountFromWords extends ImportKeyEvent {
  const FindAccountFromWords();

  @override
  String toString() => 'FindAccountFromWords ';
}

class OnUserPastedWords extends ImportKeyEvent {
  const OnUserPastedWords();

  @override
  String toString() => 'OnUserPastedWords ';
}
