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
  final bool isAccountReadyToClaim;
  final bool isAccountMissingSignatures;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardians,
    required this.userGuardiansData,
    this.errorMessage,
    required this.confirmedGuardianSignatures,
    required this.isAccountReadyToClaim,
    required this.isAccountMissingSignatures,
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
        isAccountReadyToClaim,
        isAccountMissingSignatures,
    alreadySignedGuardians,
      ];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
    String? linkToActivateGuardians,
    List<String>? userGuardians,
    List<MemberModel>? userGuardiansData,
    String? errorMessage,
    int? confirmedGuardianSignatures,
    bool? isAccountReadyToClaim,
    bool? isAccountMissingSignatures,
    List<String>? alreadySignedGuardians,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      userGuardians: userGuardians ?? this.userGuardians,
      userGuardiansData: userGuardiansData ?? this.userGuardiansData,
      errorMessage: errorMessage,
      confirmedGuardianSignatures: confirmedGuardianSignatures ?? this.confirmedGuardianSignatures,
      isAccountReadyToClaim: isAccountReadyToClaim ?? this.isAccountReadyToClaim,
      isAccountMissingSignatures: isAccountMissingSignatures ?? this.isAccountMissingSignatures,
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
      isAccountReadyToClaim: false,
      isAccountMissingSignatures: true,
      alreadySignedGuardians: []
    );
  }
}
