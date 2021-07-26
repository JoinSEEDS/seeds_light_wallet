import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';

/// --- STATES
class DeeplinkState extends Equatable {
  final GuardianRecoveryRequestData? guardianRecoveryRequestData;

  const DeeplinkState({this.guardianRecoveryRequestData});

  @override
  List<Object?> get props => [guardianRecoveryRequestData];

  DeeplinkState copyWith({
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
  }) {
    return DeeplinkState(guardianRecoveryRequestData: showGuardianApproveOrDenyScreen);
  }

  factory DeeplinkState.initial() {
    return const DeeplinkState();
  }
}
