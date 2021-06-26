import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String userAccount;
  final String linkToActivateGuardians;
  final List<String> userGuardians;
  final List<String> alreadySignedGuardians;
  final List<MemberModel> userGuardiansData;
  final int confirmedGuardianSignatures;
  final RecoveryStatus recoveryStatus;
  final int timeLockSeconds;
  final CurrentRemainingTime? currentRemainingTime;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardians,
    required this.userGuardiansData,
    this.errorMessage,
    required this.confirmedGuardianSignatures,
    required this.recoveryStatus,
    required this.alreadySignedGuardians,
    required this.timeLockSeconds,
    this.currentRemainingTime,
    required this.userAccount,
  });

  @override
  List<Object?> get props => [
        pageState,
        linkToActivateGuardians,
        userGuardians,
        userGuardiansData,
        errorMessage,
        confirmedGuardianSignatures,
        recoveryStatus,
        alreadySignedGuardians,
        timeLockSeconds,
        userAccount,
      ];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
    String? linkToActivateGuardians,
    List<String>? userGuardians,
    List<MemberModel>? userGuardiansData,
    String? errorMessage,
    int? confirmedGuardianSignatures,
    List<String>? alreadySignedGuardians,
    RecoveryStatus? recoveryStatus,
    int? timeLockSeconds,
    CurrentRemainingTime? currentRemainingTime,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      userGuardians: userGuardians ?? this.userGuardians,
      userGuardiansData: userGuardiansData ?? this.userGuardiansData,
      errorMessage: errorMessage,
      confirmedGuardianSignatures: confirmedGuardianSignatures ?? this.confirmedGuardianSignatures,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      alreadySignedGuardians: alreadySignedGuardians ?? this.alreadySignedGuardians,
      timeLockSeconds: timeLockSeconds ?? this.timeLockSeconds,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      userAccount: userAccount,
    );
  }

  factory RecoverAccountFoundState.initial(List<String> userGuardians, String userAccount) {
    return RecoverAccountFoundState(
      pageState: PageState.initial,
      linkToActivateGuardians: "",
      userGuardians: userGuardians,
      userGuardiansData: [],
      confirmedGuardianSignatures: 0,
      recoveryStatus: RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN,
      alreadySignedGuardians: [],
      timeLockSeconds: 0,
      userAccount: userAccount,
    );
  }
}

enum RecoveryStatus {
  WAITING_FOR_GUARDIANS_TO_SIGN,
  WAITING_FOR_24_HOUR_COOL_PERIOD,
  READY_TO_CLAIM_ACCOUNT,
}
