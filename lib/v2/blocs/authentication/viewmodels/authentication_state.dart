import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/main.dart' show SeedsMaterialApp;
import 'package:seeds/v2/screens/app/app.dart';
import 'package:seeds/v2/screens/verification/verification_screen.dart';

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
  final bool showResumeAuth;
  final List<Widget> appScreens;

  const AuthenticationState({
    required this.authStatus,
    required this.showResumeAuth,
    required this.appScreens,
  });

  @override
  List<Object?> get props => [authStatus, showResumeAuth, appScreens];

  AuthenticationState copyWith({AuthStatus? authStatus, bool? showResumeAuth, List<Widget>? appScreens}) {
    return AuthenticationState(
      authStatus: authStatus ?? this.authStatus,
      showResumeAuth: showResumeAuth ?? this.showResumeAuth,
      appScreens: appScreens ?? this.appScreens,
    );
  }

  factory AuthenticationState.initial() {
    return AuthenticationState(
      authStatus: AuthStatus.initial,
      showResumeAuth: false,
      appScreens: [SeedsMaterialApp(home: const VerificationScreen()), const App()],
    );
  }
}
