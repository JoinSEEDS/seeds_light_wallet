part of 'authentication_bloc.dart';

enum AuthStatus {
  initial,
  emptyAccount,
  emptyPasscode,
  inviteLink,
  locked,
  unlocked,
  recoveryMode,
}

class AuthenticationState extends Equatable {
  final AuthStatus authStatus;

  const AuthenticationState({required this.authStatus});

  @override
  List<Object?> get props => [authStatus];

  AuthenticationState copyWith({AuthStatus? authStatus}) {
    return AuthenticationState(authStatus: authStatus ?? this.authStatus);
  }

  factory AuthenticationState.initial() => const AuthenticationState(authStatus: AuthStatus.initial);
}
