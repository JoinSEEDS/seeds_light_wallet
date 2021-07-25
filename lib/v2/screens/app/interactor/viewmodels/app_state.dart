import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class AppState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;
  final GuardianApproveOrDenyData? showGuardianApproveOrDenyScreen;

  const AppState({
    required this.pageState,
    this.pageCommand,
    required this.index,
    required this.hasNotification,
    required this.showGuardianRecoveryAlert,
    required this.showGuardianApproveOrDenyScreen,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        index,
        hasNotification,
        showGuardianRecoveryAlert,
        showGuardianApproveOrDenyScreen,
      ];

  AppState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    int? index,
    bool? hasNotification,
    bool? showGuardianRecoveryAlert,
    GuardianApproveOrDenyData? showGuardianApproveOrDenyScreen,
  }) {
    return AppState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
      showGuardianRecoveryAlert: showGuardianRecoveryAlert ?? this.showGuardianRecoveryAlert,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
    );
  }

  factory AppState.initial() {
    return const AppState(
      pageState: PageState.initial,
      index: 0,
      hasNotification: false,
      showGuardianRecoveryAlert: false,
      showGuardianApproveOrDenyScreen: null,
    );
  }
}

class GuardianApproveOrDenyData {
  final String guardianAccount;
  final String publicKey;

  GuardianApproveOrDenyData({
    required this.guardianAccount,
    required this.publicKey,
  });
}
