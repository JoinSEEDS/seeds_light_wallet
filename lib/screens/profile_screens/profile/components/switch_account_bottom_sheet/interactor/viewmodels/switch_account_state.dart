part of 'switch_account_bloc.dart';

class SwitchAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<ProfileModel> accounts;
  final ProfileModel? currentAcccout;
  final List<String> publicKeys;
  final AuthDataModel? authDataModel;
  final bool isRecoverPharseEnabled;

  const SwitchAccountState({
    required this.pageState,
    this.errorMessage,
    required this.accounts,
    this.currentAcccout,
    required this.publicKeys,
    this.authDataModel,
    required this.isRecoverPharseEnabled,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        accounts,
        currentAcccout,
        publicKeys,
        authDataModel,
        isRecoverPharseEnabled,
      ];

  SwitchAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? accounts,
    ProfileModel? currentAcccout,
    List<String>? publicKeys,
    AuthDataModel? authDataModel,
    bool? isRecoverPharseEnabled,
  }) {
    return SwitchAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      accounts: accounts ?? this.accounts,
      currentAcccout: currentAcccout,
      publicKeys: publicKeys ?? this.publicKeys,
      authDataModel: authDataModel,
      isRecoverPharseEnabled: isRecoverPharseEnabled ?? this.isRecoverPharseEnabled,
    );
  }

  factory SwitchAccountState.initial(bool isRecoverPharseEnabled) {
    return SwitchAccountState(
      pageState: PageState.initial,
      accounts: [],
      publicKeys: [],
      isRecoverPharseEnabled: isRecoverPharseEnabled,
    );
  }
}
