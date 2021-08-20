import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/blocs/deeplink/model/invite_link_data.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';

/// --- STATES
class DeeplinkState extends Equatable {
  final GuardianRecoveryRequestData? guardianRecoveryRequestData;
  final InviteLinkData? inviteLinkData;
  final ScanQrCodeResultData? signingRequest;

  const DeeplinkState({
    this.guardianRecoveryRequestData,
    this.inviteLinkData,
    this.signingRequest,
  });

  @override
  List<Object?> get props => [guardianRecoveryRequestData, inviteLinkData, signingRequest];

  DeeplinkState copyWith({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    InviteLinkData? inviteLinkData,
    ScanQrCodeResultData? signingRequest,
  }) {
    return DeeplinkState(
        guardianRecoveryRequestData: showGuardianApproveOrDenyScreen,
        inviteLinkData: inviteLinkData,
        signingRequest: signingRequest);
  }

  factory DeeplinkState.initial() {
    return const DeeplinkState();
  }
}
