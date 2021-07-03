import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? userName;
  final bool isValidUsername;
  final List<String> userGuardians;
  final PageCommand? pageCommand;

  const RecoverAccountState(
      {required this.pageState,
      this.errorMessage,
      required this.isValidUsername,
      required this.userGuardians,
      this.userName,
      this.pageCommand});

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        isValidUsername,
        userGuardians,
        userName,
        pageCommand,
      ];

  RecoverAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isValidUsername,
    List<String>? userGuardians,
    String? userName,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isValidUsername: isValidUsername ?? this.isValidUsername,
      userGuardians: userGuardians ?? this.userGuardians,
      userName: userName ?? this.userName,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(
      pageState: PageState.initial,
      isValidUsername: false,
      userGuardians: [],
    );
  }
}
