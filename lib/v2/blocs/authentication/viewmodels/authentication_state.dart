import 'package:equatable/equatable.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/features/biometrics/auth_state.dart';

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
  final AuthStatus authStatus;
  final AuthState authState;
  final List<AuthType> authTypesAvailable;
  final AuthType preferred;
  final String errorMessage;

  const AuthenticationState({
    this.authStatus,
    this.authState,
    this.authTypesAvailable,
    this.preferred,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        authStatus,
        authState,
        authTypesAvailable,
        preferred,
        errorMessage,
      ];

  AuthenticationState copyWith({
    AuthStatus authStatus,
    AuthState authState,
    List<AuthType> authTypesAvailable,
    AuthType preferred,
    String errorMessage,
  }) {
    return AuthenticationState(
      authStatus: authStatus ?? this.authStatus,
      authState: authState ?? this.authState,
      authTypesAvailable: authTypesAvailable ?? this.authTypesAvailable,
      preferred: preferred ?? this.preferred,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory AuthenticationState.initial() {
    return const AuthenticationState(authStatus: AuthStatus.initial);
  }
}
