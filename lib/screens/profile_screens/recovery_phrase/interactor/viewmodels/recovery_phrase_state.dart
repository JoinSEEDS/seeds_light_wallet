part of 'recovery_phrase_bloc.dart';

class RecoveryPhraseState {
  final List<String> words;

  String get printableWords => words.join(' ');

  const RecoveryPhraseState({required this.words});

  factory RecoveryPhraseState.initial(AuthDataModel authData) {
    return RecoveryPhraseState(words: authData.words.first.split('-'));
  }
}
