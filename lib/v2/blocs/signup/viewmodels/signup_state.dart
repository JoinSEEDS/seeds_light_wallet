part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({required this.claimInviteState});

  final ClaimInviteState claimInviteState;

  factory SignupState.initial() =>
      SignupState(claimInviteState: ClaimInviteState.initial());

  SignupState copyWith({
    ClaimInviteState? claimInviteState,
  }) =>
      SignupState(
        claimInviteState: claimInviteState ?? this.claimInviteState,
      );

  @override
  List<Object?> get props => [
        claimInviteState.props,
      ];
}
