part of 'deeplink_bloc.dart';

class DeeplinkState extends Equatable {
  final GuardianRecoveryRequestData? guardianRecoveryRequestData;
  final InviteLinkData? inviteLinkData;
  final ScanQrCodeResultData? signingRequest;
  final RegionLinkData? regionLinkData;

  const DeeplinkState({
    this.guardianRecoveryRequestData,
    this.inviteLinkData,
    this.signingRequest,
    this.regionLinkData,
  });

  @override
  List<Object?> get props => [
        guardianRecoveryRequestData,
        inviteLinkData,
        signingRequest,
        regionLinkData,
      ];

  DeeplinkState copyWith({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    InviteLinkData? inviteLinkData,
    ScanQrCodeResultData? signingRequest,
    RegionLinkData? regionLinkData,
  }) {
    return DeeplinkState(
      guardianRecoveryRequestData: showGuardianApproveOrDenyScreen,
      inviteLinkData: inviteLinkData,
      signingRequest: signingRequest,
      regionLinkData: regionLinkData,
    );
  }

  factory DeeplinkState.initial() => const DeeplinkState();
}
