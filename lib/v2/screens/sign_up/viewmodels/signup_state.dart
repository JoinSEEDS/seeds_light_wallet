part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    required this.pageContent,
    required this.claimInviteState,
    required this.displayNameState,
    required this.createUsernameState,
    required this.addPhoneNumberState,
  });

  final ClaimInviteState claimInviteState;
  final PageContent pageContent;
  final DisplayNameState displayNameState;
  final CreateUsernameState createUsernameState;
  final AddPhoneNumberState addPhoneNumberState;

  factory SignupState.initial() => SignupState(
        pageContent: PageContent.CLAIM_INVITE,
        claimInviteState: ClaimInviteState.initial(),
        displayNameState: DisplayNameState.initial(),
        createUsernameState: CreateUsernameState.initial(),
        addPhoneNumberState: AddPhoneNumberState.initial(),
      );

  SignupState copyWith({
    PageContent? pageContent,
    ClaimInviteState? claimInviteState,
    DisplayNameState? displayNameState,
    CreateUsernameState? createUsernameState,
    AddPhoneNumberState? addPhoneNumberState,
  }) =>
      SignupState(
        pageContent: pageContent ?? this.pageContent,
        claimInviteState: claimInviteState ?? this.claimInviteState,
        displayNameState: displayNameState ?? this.displayNameState,
        createUsernameState: createUsernameState ?? this.createUsernameState,
        addPhoneNumberState: addPhoneNumberState ?? this.addPhoneNumberState,
      );

  @override
  List<Object?> get props => [
        pageContent,
        claimInviteState.props,
        displayNameState,
        createUsernameState,
        addPhoneNumberState,
      ];
}

enum PageContent {
  CLAIM_INVITE,
  DISPLAY_NAME,
  USERNAME,
  PHONE_NUMBER,
}
