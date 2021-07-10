import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

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
    return WalletState(pageState: PageState.initial, profile: ProfileModel(account: settingsStorage.accountName, timestamp: 0));
  }
}
