import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }
enum GuardiansStatus { active, inactive, readyToActivate }

/// STATE
class RecoveryPhraseState extends Equatable {
  final PageState pageState;

  const RecoveryPhraseState({
    required this.pageState,
  });

  @override
  List<Object?> get props => [
        pageState,
      ];

  RecoveryPhraseState copyWith({
    PageState? pageState,
  }) {
    return RecoveryPhraseState(
      pageState: pageState ?? this.pageState,
    );
  }

  factory RecoveryPhraseState.initial() {
    return const RecoveryPhraseState(
      pageState: PageState.initial,
    );
  }
}
