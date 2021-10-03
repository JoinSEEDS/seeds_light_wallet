import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ImportKeyEvent extends Equatable {
  const ImportKeyEvent();

  @override
  List<Object> get props => [];
}

class FindAccountByKey extends ImportKeyEvent {
  final String userKey;

  const FindAccountByKey({required this.userKey});

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
