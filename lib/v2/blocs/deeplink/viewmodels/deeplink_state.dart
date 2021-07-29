import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/v2/blocs/deeplink/model/invite_link_data.dart';

/// --- STATES
class DeeplinkState extends Equatable {
  final GuardianRecoveryRequestData? guardianRecoveryRequestData;
  final InviteLinkData? inviteLinkData;

  const DeeplinkState({
    this.guardianRecoveryRequestData,
    this.inviteLinkData,
  });

  @override
  List<Object?> get props => [guardianRecoveryRequestData, inviteLinkData];

  DeeplinkState copyWith({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    InviteLinkData? inviteLinkData,
  }) {
    return DeeplinkState(
      guardianRecoveryRequestData: showGuardianApproveOrDenyScreen,
      inviteLinkData: inviteLinkData,
    );
  }

  factory DeeplinkState.initial() {
    return const DeeplinkState();
  }
}
