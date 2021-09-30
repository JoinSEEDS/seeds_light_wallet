import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? privateKey;
  final List<ProfileModel> accounts;
  final bool enableButton;
  final Map<int, String> words;

  const ImportKeyState({
    required this.pageState,
    this.errorMessage,
    required this.accounts,
    this.privateKey,
    required this.enableButton,
    required this.words,
  });

  bool get areAllWordsEntered {
    return words.length == 12 && !words.containsValue('');
  }

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        privateKey,
        accounts,
        enableButton,
        words,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? accounts,
    String? privateKey,
    bool? enableButton,
    Map<int, String>? words,
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      accounts: accounts ?? this.accounts,
      privateKey: privateKey ?? this.privateKey,
      enableButton: enableButton ?? this.enableButton,
      words: words ?? this.words,
    );
  }

  factory ImportKeyState.initial() {
    // ignore: prefer_const_constructors
    return ImportKeyState(
      pageState: PageState.initial,
      accounts: [],
      enableButton: false,
      words: {},
    );
  }
}
