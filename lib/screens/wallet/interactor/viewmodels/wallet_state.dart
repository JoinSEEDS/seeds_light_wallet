part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel profile;

  const WalletState({
    required this.pageState,
    required this.profile,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        profile,
        errorMessage,
      ];

  WalletState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
  }) {
    return WalletState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      profile: profile ?? this.profile,
    );
  }

  factory WalletState.initial() {
    return WalletState(
      pageState: PageState.initial,
      profile: ProfileModel(
        account: settingsStorage.accountName,
        status: ProfileStatus.visitor,
        type: '',
        nickname: '',
        image: '',
        story: '',
        roles: '',
        skills: '',
        interests: '',
        reputation: 0,
        timestamp: 0,
      ),
    );
  }
}
