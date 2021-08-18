import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? privateKey;
  final List<ProfileModel> accounts;
  final bool enableButton;

  const ImportKeyState({
    required this.pageState,
    this.errorMessage,
    required this.accounts,
    this.privateKey,
    required this.enableButton,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        privateKey,
        accounts,
        enableButton,
      ];

  ImportKeyState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? accounts,
    String? privateKey,
    bool? enableButton,
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      accounts: accounts ?? this.accounts,
      privateKey: privateKey ?? this.privateKey,
      enableButton: enableButton ?? this.enableButton,
    );
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      pageState: PageState.initial,
      accounts: [],
      enableButton: false,
    );
  }
}
