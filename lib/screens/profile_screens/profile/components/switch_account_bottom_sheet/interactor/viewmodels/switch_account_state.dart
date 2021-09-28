part of 'switch_account_bloc.dart';

class SwitchAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<ProfileModel> accounts;
  final ProfileModel? currentAcccout;

  const SwitchAccountState({
    required this.pageState,
    this.errorMessage,
    required this.accounts,
    this.currentAcccout,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        accounts,
        currentAcccout,
      ];

  SwitchAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? accounts,
    ProfileModel? currentAcccout,
  }) {
    return SwitchAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      accounts: accounts ?? this.accounts,
      currentAcccout: currentAcccout,
    );
  }

  factory SwitchAccountState.initial() {
    return const SwitchAccountState(pageState: PageState.initial, accounts: []);
  }
}
