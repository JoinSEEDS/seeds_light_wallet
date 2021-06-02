part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    required this.pageContent,
    required this.claimInviteState,
    required this.displayNameState,
  });

  final ClaimInviteState claimInviteState;
  final PageContent pageContent;
  final DisplayNameState displayNameState;

  factory SignupState.initial() => SignupState(
        pageContent: PageContent.CLAIM_INVITE,
        claimInviteState: ClaimInviteState.initial(),
        displayNameState: DisplayNameState.initial(),
      );

  SignupState copyWith({
    PageContent? pageContent,
    ClaimInviteState? claimInviteState,
    DisplayNameState? displayNameState,
  }) =>
      SignupState(
        pageContent: pageContent ?? this.pageContent,
        claimInviteState: claimInviteState ?? this.claimInviteState,
        displayNameState: displayNameState ?? this.displayNameState,
      );

  @override
  List<Object?> get props => [
        pageContent,
        claimInviteState.props,
        displayNameState,
      ];
}

enum PageContent {
  CLAIM_INVITE,
  DISPLAY_NAME,
  USERNAME,
  PHONE_NUMBER,
}
