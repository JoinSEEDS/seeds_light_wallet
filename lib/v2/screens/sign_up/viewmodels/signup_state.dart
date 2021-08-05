part of 'signup_bloc.dart';

enum SignupScreens {
  claimInvite,
  displayName,
  username,
  phoneNumber,
}

class SignupState extends Equatable {
  final ClaimInviteState claimInviteState;
  final SignupScreens signupScreens;
  final DisplayNameState displayNameState;
  final CreateUsernameState createUsernameState;
  final AddPhoneNumberState addPhoneNumberState;

  const SignupState({
    required this.signupScreens,
    required this.claimInviteState,
    required this.displayNameState,
    required this.createUsernameState,
    required this.addPhoneNumberState,
  });

  @override
  List<Object?> get props => [
        SignupScreens,
        claimInviteState.props,
        displayNameState,
        createUsernameState,
        addPhoneNumberState,
      ];

  SignupState copyWith({
    SignupScreens? signupScreens,
    ClaimInviteState? claimInviteState,
    DisplayNameState? displayNameState,
    CreateUsernameState? createUsernameState,
    AddPhoneNumberState? addPhoneNumberState,
  }) =>
      SignupState(
        signupScreens: signupScreens ?? this.signupScreens,
        claimInviteState: claimInviteState ?? this.claimInviteState,
        displayNameState: displayNameState ?? this.displayNameState,
        createUsernameState: createUsernameState ?? this.createUsernameState,
        addPhoneNumberState: addPhoneNumberState ?? this.addPhoneNumberState,
      );

  factory SignupState.initial() => SignupState(
        signupScreens: SignupScreens.claimInvite,
        claimInviteState: ClaimInviteState.initial(),
        displayNameState: DisplayNameState.initial(),
        createUsernameState: CreateUsernameState.initial(),
        addPhoneNumberState: AddPhoneNumberState.initial(),
      );
}
