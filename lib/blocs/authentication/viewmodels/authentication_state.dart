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
  final bool isOnResumeAuth;

  const AuthenticationState({required this.authStatus, required this.isOnResumeAuth});

  @override
  List<Object?> get props => [authStatus, isOnResumeAuth];

  AuthenticationState copyWith({AuthStatus? authStatus, bool? isOnResumeAuth}) {
    return AuthenticationState(
      authStatus: authStatus ?? this.authStatus,
      isOnResumeAuth: isOnResumeAuth ?? this.isOnResumeAuth,
    );
  }

  factory AuthenticationState.initial() {
    return const AuthenticationState(authStatus: AuthStatus.initial, isOnResumeAuth: false);
  }
}
