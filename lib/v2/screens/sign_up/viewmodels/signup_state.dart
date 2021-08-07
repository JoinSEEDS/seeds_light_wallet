part of 'signup_bloc.dart';

enum SignupScreens { claimInvite, displayName, username }

class SignupState extends Equatable {
  final ClaimInviteState claimInviteState;
  final SignupScreens signupScreens;
  final DisplayNameState displayNameState;
  final CreateUsernameState createUsernameState;

  const SignupState({
    required this.signupScreens,
    required this.claimInviteState,
    required this.displayNameState,
    required this.createUsernameState,
  });

  @override
  List<Object?> get props => [
        signupScreens,
        claimInviteState.props,
        displayNameState,
        createUsernameState,
      ];

  SignupState copyWith({
    SignupScreens? signupScreens,
    ClaimInviteState? claimInviteState,
    DisplayNameState? displayNameState,
    CreateUsernameState? createUsernameState,
  }) =>
      SignupState(
        signupScreens: signupScreens ?? this.signupScreens,
        claimInviteState: claimInviteState ?? this.claimInviteState,
        displayNameState: displayNameState ?? this.displayNameState,
        createUsernameState: createUsernameState ?? this.createUsernameState,
      );

  factory SignupState.initial() => SignupState(
        signupScreens: SignupScreens.claimInvite,
        claimInviteState: ClaimInviteState.initial(),
        displayNameState: DisplayNameState.initial(),
        createUsernameState: CreateUsernameState.initial(),
      );
}
