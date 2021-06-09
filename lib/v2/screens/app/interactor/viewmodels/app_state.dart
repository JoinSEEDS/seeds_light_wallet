import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class AppState extends Equatable {
  final PageState pageState;
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;
  final PageCommand? pageCommand;

  const AppState({
    required this.index,
    required this.hasNotification,
    required this.showGuardianRecoveryAlert,
    required this.pageState,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        index,
        hasNotification,
        pageState,
        showGuardianRecoveryAlert,
        pageCommand,
      ];

  AppState copyWith({
    int? index,
    bool? hasNotification,
    bool? showGuardianRecoveryAlert,
    PageState? pageState,
    PageCommand? pageCommand,
  }) {
    return AppState(
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
      showGuardianRecoveryAlert: showGuardianRecoveryAlert ?? this.showGuardianRecoveryAlert,
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
    );
  }

  factory AppState.initial() {
    return const AppState(
      pageState: PageState.initial,
      index: 0,
      hasNotification: false,
      showGuardianRecoveryAlert: false,
    );
  }
}
