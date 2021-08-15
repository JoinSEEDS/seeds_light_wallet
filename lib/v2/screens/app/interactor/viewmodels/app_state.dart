import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class AppState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;
  final GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen;
  // final ScanESRResultData? signingRequest;

  const AppState({
    required this.pageState,
    this.pageCommand,
    required this.index,
    required this.hasNotification,
    required this.showGuardianRecoveryAlert,
    required this.showGuardianApproveOrDenyScreen,
    // this.signingRequest,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        index,
        hasNotification,
        showGuardianRecoveryAlert,
        showGuardianApproveOrDenyScreen,
        // signingRequest,
      ];

  AppState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    int? index,
    bool? hasNotification,
    bool? showGuardianRecoveryAlert,
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    // ScanESRResultData? signingRequest,
  }) {
    return AppState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
      showGuardianRecoveryAlert: showGuardianRecoveryAlert ?? this.showGuardianRecoveryAlert,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
      // signingRequest: signingRequest ?? this.signingRequest,
    );
  }

  factory AppState.initial({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    // ScanESRResultData? signingRequest,
  }) {
    return AppState(
      pageState: PageState.initial,
      index: 0,
      hasNotification: false,
      showGuardianRecoveryAlert: false,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
      // signingRequest: signingRequest,
    );
  }
}
