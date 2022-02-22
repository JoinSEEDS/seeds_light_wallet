part of 'vouched_bloc.dart';

class VouchedState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final List<ProfileModel> vouched;
  final bool canVouch;
  final ProfileModel? profile;

  const VouchedState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.vouched,
    required this.canVouch,
    this.profile,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        vouched,
        canVouch,
        profile,
      ];

  VouchedState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    List<ProfileModel>? vouched,
    bool? canVouch,
    ProfileModel? profile,
  }) {
    return VouchedState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      vouched: vouched ?? this.vouched,
      canVouch: canVouch ?? this.canVouch,
      profile: profile ?? this.profile,
    );
  }

  factory VouchedState.initial() {
    return const VouchedState(
      pageState: PageState.initial,
      vouched: [],
      canVouch: false,
    );
  }
}
