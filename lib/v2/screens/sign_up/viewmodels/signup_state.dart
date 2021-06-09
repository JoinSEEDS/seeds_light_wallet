part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    required this.pageContent,
    required this.claimInviteState,
    required this.displayNameState,
    required this.createUsernameState,
  });

  final ClaimInviteState claimInviteState;
  final PageContent pageContent;
  final DisplayNameState displayNameState;
  final CreateUsernameState createUsernameState;

  factory SignupState.initial() => SignupState(
        pageContent: PageContent.CLAIM_INVITE,
        claimInviteState: ClaimInviteState.initial(),
        displayNameState: DisplayNameState.initial(),
        createUsernameState: CreateUsernameState.initial(),
      );

  SignupState copyWith({
    PageContent? pageContent,
    ClaimInviteState? claimInviteState,
    DisplayNameState? displayNameState,
    CreateUsernameState? createUsernameState,
  }) =>
      SignupState(
        pageContent: pageContent ?? this.pageContent,
        claimInviteState: claimInviteState ?? this.claimInviteState,
        displayNameState: displayNameState ?? this.displayNameState,
        createUsernameState: createUsernameState ?? this.createUsernameState,
      );

  @override
  List<Object?> get props => [
        pageContent,
        claimInviteState.props,
        displayNameState,
        createUsernameState,
      ];
}

enum PageContent {
  CLAIM_INVITE,
  DISPLAY_NAME,
  USERNAME,
  PHONE_NUMBER,
}
