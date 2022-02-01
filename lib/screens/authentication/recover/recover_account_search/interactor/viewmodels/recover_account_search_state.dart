part of 'recover_account_search_bloc.dart';

class RecoverAccountSearchState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RecoverAccountSearchError? errorMessage;
  final bool isGuardianActive;
  final List<String> userGuardians;
  final ProfileModel? accountInfo;

  const RecoverAccountSearchState({
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

  RecoverAccountSearchState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RecoverAccountSearchError? errorMessage,
    bool? isGuardianActive,
    List<String>? userGuardians,
    ProfileModel? accountInfo,
  }) {
    return RecoverAccountSearchState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isGuardianActive: isGuardianActive ?? this.isGuardianActive,
      userGuardians: userGuardians ?? this.userGuardians,
      accountInfo: accountInfo ?? this.accountInfo,
    );
  }

  factory RecoverAccountSearchState.initial() {
    return const RecoverAccountSearchState(
      pageState: PageState.initial,
      isGuardianActive: false,
      userGuardians: [],
    );
  }
}
