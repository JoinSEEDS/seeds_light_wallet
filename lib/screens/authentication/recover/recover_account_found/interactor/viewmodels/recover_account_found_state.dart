part of 'recover_account_found_bloc.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;
  final RecoverAccountFoundError? error;
  final String userAccount;
  final Uri? linkToActivateGuardians;
  final List<String> alreadySignedGuardians;
  final List<ProfileModel> userGuardiansData;
  final int confirmedGuardianSignatures;
  final RecoveryStatus recoveryStatus;
  final int timeLockExpirySeconds;
  final CurrentRemainingTime? currentRemainingTime;
  final PageCommand? pageCommand;

  int get timeRemaining => timeLockExpirySeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardiansData,
    this.error,
    required this.confirmedGuardianSignatures,
    required this.recoveryStatus,
    required this.alreadySignedGuardians,
    required this.timeLockExpirySeconds,
    this.currentRemainingTime,
    required this.userAccount,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        linkToActivateGuardians,
        userGuardiansData,
        error,
        confirmedGuardianSignatures,
        recoveryStatus,
        alreadySignedGuardians,
        timeLockExpirySeconds,
        userAccount,
        pageCommand,
        currentRemainingTime,
      ];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
    Uri? linkToActivateGuardians,
    List<String>? userGuardians,
    List<ProfileModel>? userGuardiansData,
    RecoverAccountFoundError? error,
    int? confirmedGuardianSignatures,
    List<String>? alreadySignedGuardians,
    RecoveryStatus? recoveryStatus,
    int? timeLockExpirySeconds,
    CurrentRemainingTime? currentRemainingTime,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      userGuardiansData: userGuardiansData ?? this.userGuardiansData,
      error: error,
      confirmedGuardianSignatures: confirmedGuardianSignatures ?? this.confirmedGuardianSignatures,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      alreadySignedGuardians: alreadySignedGuardians ?? this.alreadySignedGuardians,
      timeLockExpirySeconds: timeLockExpirySeconds ?? this.timeLockExpirySeconds,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      userAccount: userAccount,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountFoundState.initial(String userAccount) {
    return RecoverAccountFoundState(
      pageState: PageState.initial,
      linkToActivateGuardians: null,
      userGuardiansData: [],
      confirmedGuardianSignatures: 0,
      recoveryStatus: RecoveryStatus.waitingForGuardiansToSign,
      alreadySignedGuardians: [],
      timeLockExpirySeconds: 0,
      userAccount: userAccount,
    );
  }
}

enum RecoveryStatus {
  waitingForGuardiansToSign,
  waitingFor24HourCoolPeriod,
  readyToClaimAccount,
}
