part of 'switch_account_bloc.dart';

class SwitchAccountState extends Equatable {
  final PageState pageState;
  final ImportKeyError? error;
  final List<ProfileModel> accounts;
  final ProfileModel? currentAcccout;
  final List<Keys> keys;
  final AuthDataModel? authDataModel;
  final bool isRecoverPharseEnabled;

  const SwitchAccountState({
    required this.pageState,
    this.error,
    required this.accounts,
    this.currentAcccout,
    required this.keys,
    this.authDataModel,
    required this.isRecoverPharseEnabled,
  });

  @override
  List<Object?> get props => [
        pageState,
        accounts,
        currentAcccout,
        keys,
        authDataModel,
        isRecoverPharseEnabled,
      ];

  SwitchAccountState copyWith({
    PageState? pageState,
    ImportKeyError? error,
    List<ProfileModel>? accounts,
    ProfileModel? currentAcccout,
    List<Keys>? keys,
    AuthDataModel? authDataModel,
    bool? isRecoverPharseEnabled,
  }) {
    return SwitchAccountState(
      pageState: pageState ?? this.pageState,
      error: error,
      accounts: accounts ?? this.accounts,
      currentAcccout: currentAcccout,
      keys: keys ?? this.keys,
      authDataModel: authDataModel,
      isRecoverPharseEnabled: isRecoverPharseEnabled ?? this.isRecoverPharseEnabled,
    );
  }

  factory SwitchAccountState.initial(bool isRecoverPharseEnabled) {
    return SwitchAccountState(
      pageState: PageState.initial,
      accounts: [],
      keys: [],
      isRecoverPharseEnabled: isRecoverPharseEnabled,
    );
  }
}
