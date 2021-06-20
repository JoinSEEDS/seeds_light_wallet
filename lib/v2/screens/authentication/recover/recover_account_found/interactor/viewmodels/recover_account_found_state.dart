import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String linkToActivateGuardians;
  final List<String> userGuardians;
  final List<String> alreadySignedGuardians;
  final List<MemberModel> userGuardiansData;
  final int confirmedGuardianSignatures;
  final RecoveryStatus recoveryStatus;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardians,
    required this.userGuardiansData,
    this.errorMessage,
    required this.confirmedGuardianSignatures,
    required this.recoveryStatus,
    required this.alreadySignedGuardians,
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
    );
  }

  factory RecoverAccountFoundState.initial(List<String> userGuardians) {
    return RecoverAccountFoundState(
        pageState: PageState.initial,
        linkToActivateGuardians: "",
        userGuardians: userGuardians,
        userGuardiansData: [],
        confirmedGuardianSignatures: 0,
        recoveryStatus: RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN,
        alreadySignedGuardians: []);
  }
}

enum RecoveryStatus {
  WAITING_FOR_GUARDIANS_TO_SIGN,
  WAITING_FOR_24_HOUR_COOL_PERIOD,
  READY_TO_CLAIM_ACCOUNT,
}
