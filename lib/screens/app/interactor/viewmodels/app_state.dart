import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

/// STATE
class AppState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;
  final GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen;

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
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
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

  factory AppState.initial(GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen) {
    return AppState(
      pageState: PageState.initial,
      index: 0,
      hasNotification: false,
      showGuardianRecoveryAlert: false,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
    );
  }
}
