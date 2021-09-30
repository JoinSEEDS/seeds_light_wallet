import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ImportWordsEvent extends Equatable {
  const ImportWordsEvent();

  @override
  List<Object> get props => [];
}

class FindAccountByKey extends ImportWordsEvent {
  final String userKey;

  const FindAccountByKey({required this.userKey});

  @override
  String toString() => 'FindAccountByKey';
}

class AccountSelected extends ImportWordsEvent {
  final String account;

  const AccountSelected({required this.account});

  @override
  String toString() => 'AccountSelected: { account: $account }';
}

class OnWordChange extends ImportWordsEvent {
  final String word;
  final int wordIndex;

  const OnWordChange({required this.word, required this.wordIndex});

  @override
  String toString() => 'OnWordChange: { word: $word index: $wordIndex}';
}

class OnPrivateKeyChange extends ImportWordsEvent {
  final String privateKeyChanged;

  const OnPrivateKeyChange({required this.privateKeyChanged});

  @override
  String toString() => 'OnPrivateKeyChange: { inputChange: $privateKeyChanged }';
}

class FindAccountFromWords extends ImportWordsEvent {
  const FindAccountFromWords();

  @override
  String toString() => 'FindAccountFromWords ';
}
