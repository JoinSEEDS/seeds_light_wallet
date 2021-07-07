import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class WalletState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;

  const WalletState({
    required this.pageState,
    this.profile,
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
    return const WalletState(pageState: PageState.initial);
  }
}
