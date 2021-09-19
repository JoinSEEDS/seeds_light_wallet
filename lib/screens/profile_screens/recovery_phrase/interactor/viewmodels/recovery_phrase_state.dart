import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }
enum GuardiansStatus { active, inactive, readyToActivate }

/// STATE
class RecoveryPhraseState extends Equatable {
  final PageState pageState;
  final List<String> words;

  const RecoveryPhraseState({
    required this.pageState,
    required this.words,
  });

  @override
  List<Object?> get props => [
        pageState,
        words,
      ];

  RecoveryPhraseState copyWith({
    PageState? pageState,
    List<String>? words,
  }) {
    return RecoveryPhraseState(pageState: pageState ?? this.pageState, words: words ?? this.words);
  }

  factory RecoveryPhraseState.initial(List<String> words) {
    return RecoveryPhraseState(
      pageState: PageState.initial,
      words: words,
    );
  }
}
