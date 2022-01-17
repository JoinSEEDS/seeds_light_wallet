part of 'deeplink_bloc.dart';

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
  List<Object?> get props => [
        guardianRecoveryRequestData,
        inviteLinkData,
        signingRequest,
      ];

  DeeplinkState copyWith({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    InviteLinkData? inviteLinkData,
    ScanQrCodeResultData? signingRequest,
  }) {
    return DeeplinkState(
      guardianRecoveryRequestData: showGuardianApproveOrDenyScreen,
      inviteLinkData: inviteLinkData,
      signingRequest: signingRequest,
    );
  }

  factory DeeplinkState.initial() {
    return const DeeplinkState();
  }
}
