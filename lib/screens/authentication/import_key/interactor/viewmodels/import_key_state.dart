part of 'import_key_bloc.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;
  final ImportKeyError? error;
  final AuthDataModel? authData;
  final List<ProfileModel> accounts;
  final bool enableButton;
  final Map<int, String> userEnteredWords;
  final String? accountSelected;

  const ImportKeyState({
    required this.pageState,
    this.error,
    required this.accounts,
    this.authData,
    required this.enableButton,
    required this.userEnteredWords,
    this.accountSelected,
  });

  bool get areAllWordsEntered {
    return userEnteredWords.length == 12 && !userEnteredWords.containsValue('');
  }

  @override
  List<Object?> get props => [
        pageState,
        error,
        authData,
        accounts,
        enableButton,
        userEnteredWords,
        accountSelected,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    ImportKeyError? error,
    List<ProfileModel>? accounts,
    AuthDataModel? authData,
    bool? enableButton,
    Map<int, String>? userEnteredWords,
    String? accountSelected,
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
      error: error,
      accounts: accounts ?? this.accounts,
      authData: authData ?? this.authData,
      enableButton: enableButton ?? this.enableButton,
      userEnteredWords: userEnteredWords ?? this.userEnteredWords,
      accountSelected: accountSelected,
    );
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      pageState: PageState.initial,
      accounts: [],
      enableButton: false,
      userEnteredWords: {},
    );
  }
}
