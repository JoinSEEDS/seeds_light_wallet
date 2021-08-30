import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? userName;
  final bool isGuardianActive;
  final List<String> userGuardians;
  final PageCommand? pageCommand;
  final bool isValidAccount;
  final String? accountName;
  final String? accountImage;

  const RecoverAccountState({
    required this.pageState,
    this.errorMessage,
    required this.isGuardianActive,
    required this.userGuardians,
    this.userName,
    this.pageCommand,
    required this.isValidAccount,
    this.accountName,
    this.accountImage,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        isGuardianActive,
        userGuardians,
        userName,
        pageCommand,
        isValidAccount,
        accountName,
        accountImage,
      ];

  RecoverAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isGuardianActive,
    List<String>? userGuardians,
    String? userName,
    PageCommand? pageCommand,
    bool? isValidAccount,
    String? accountName,
    String? accountImage,
  }) {
    return RecoverAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isGuardianActive: isGuardianActive ?? this.isGuardianActive,
      userGuardians: userGuardians ?? this.userGuardians,
      userName: userName ?? this.userName,
      pageCommand: pageCommand,
      isValidAccount: isValidAccount ?? this.isValidAccount,
      accountName: accountName ?? this.accountName,
      accountImage: accountImage ?? this.accountImage,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(
      pageState: PageState.initial,
      isGuardianActive: false,
      userGuardians: [],
      isValidAccount: false,
    );
  }
}
