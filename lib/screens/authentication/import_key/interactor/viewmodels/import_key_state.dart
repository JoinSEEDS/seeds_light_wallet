import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final AuthDataModel? authData;
  final List<ProfileModel> accounts;
  final bool enableButton;
  final Map<int, String> userEnteredWords;

  const ImportKeyState({
    required this.pageState,
    this.errorMessage,
    required this.accounts,
    this.authData,
    required this.enableButton,
    required this.userEnteredWords,
  });

  bool get areAllWordsEntered {
    return userEnteredWords.length == 12 && !userEnteredWords.containsValue('');
  }

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        authData,
        accounts,
        enableButton,
        userEnteredWords,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? accounts,
    AuthDataModel? authData,
    bool? enableButton,
    Map<int, String>? userEnteredWords,
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      accounts: accounts ?? this.accounts,
      authData: authData ?? this.authData,
      enableButton: enableButton ?? this.enableButton,
      userEnteredWords: userEnteredWords ?? this.userEnteredWords,
    );
  }

  factory ImportKeyState.initial() {
    // ignore: prefer_const_constructors
    return ImportKeyState(
      pageState: PageState.initial,
      accounts: [],
      enableButton: false,
      userEnteredWords: {},
    );
  }
}
