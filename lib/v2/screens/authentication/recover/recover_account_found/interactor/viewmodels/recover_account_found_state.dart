import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String linkToActivateGuardians;
  final List<String> userGuardians;
  final List<MemberModel> userGuardiansData;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardians,
    required this.userGuardiansData,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        linkToActivateGuardians,
        userGuardians,
        userGuardiansData,
        errorMessage,
      ];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
    String? linkToActivateGuardians,
    List<String>? userGuardians,
    List<MemberModel>? userGuardiansData,
    String? errorMessage,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      userGuardians: userGuardians ?? this.userGuardians,
      userGuardiansData: userGuardiansData ?? this.userGuardiansData,
      errorMessage: errorMessage,
    );
  }

  factory RecoverAccountFoundState.initial(List<String> userGuardians) {
    return RecoverAccountFoundState(
      pageState: PageState.initial,
      linkToActivateGuardians: "",
      userGuardians: userGuardians,
      userGuardiansData: [],
    );
  }
}
