import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final String? errorMessage;
  final bool isGuardianActive;
  final List<String> userGuardians;
  final MemberModel? accountInfo;

  const RecoverAccountState({
    this.pageCommand,
    required this.pageState,
    this.errorMessage,
    required this.isGuardianActive,
    required this.userGuardians,
    this.accountInfo,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        errorMessage,
        isGuardianActive,
        userGuardians,
        accountInfo,
      ];

  bool get accountFound => accountInfo != null;

  RecoverAccountState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    String? errorMessage,
    bool? isGuardianActive,
    List<String>? userGuardians,
    MemberModel? accountInfo,
  }) {
    return RecoverAccountState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isGuardianActive: isGuardianActive ?? this.isGuardianActive,
      userGuardians: userGuardians ?? this.userGuardians,
      accountInfo: accountInfo ?? this.accountInfo,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(
      pageState: PageState.initial,
      isGuardianActive: false,
      userGuardians: [],
    );
  }
}
