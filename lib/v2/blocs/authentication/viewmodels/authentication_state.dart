import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  emptyAccount,
  emptyPasscode,
  locked,
  unlocked,
  recoveryMode,
}

/// --- STATES
class AuthenticationState extends Equatable {
  final AuthStatus? authStatus;

  const AuthenticationState({this.authStatus});

  @override
  List<Object?> get props => [authStatus];

  AuthenticationState copyWith({AuthStatus? authStatus}) {
    return AuthenticationState(authStatus: authStatus ?? this.authStatus);
  }

  factory AuthenticationState.initial() {
    return const AuthenticationState(authStatus: AuthStatus.initial);
  }
}
