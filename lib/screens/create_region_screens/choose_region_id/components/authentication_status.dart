import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

enum AuthenticationState { loading, valid, invalid }

class AuthenticationStatus extends StatelessWidget {
  final AuthenticationState authenticationIdState;

  const AuthenticationStatus({
    Key? key,
    required this.authenticationIdState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (authenticationIdState) {
      case AuthenticationState.loading:
        return const CircularProgressIndicator(color: AppColors.green1);
      case AuthenticationState.valid:
        return const Icon(Icons.check, size: 70, color: AppColors.green1);
      case AuthenticationState.invalid:
        return const Icon(Icons.block_flipped, size: 70, color: AppColors.red1);
    }
  }
}
