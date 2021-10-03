import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }
enum GuardiansStatus { active, inactive, readyToActivate }

/// STATE
class RecoveryPhraseState extends Equatable {
  final PageState pageState;
  final List<String> words;

  String get printableWords => words.toString();

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

  factory RecoveryPhraseState.initial(AuthDataModel authData) {
    return RecoveryPhraseState(
      pageState: PageState.initial,
      words: authData.words,
    );
  }
}
