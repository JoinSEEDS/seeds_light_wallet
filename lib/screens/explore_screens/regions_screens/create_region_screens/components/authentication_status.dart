import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

enum RegionIdStatusIcon { loading, valid, invalid }

class AuthenticationStatus extends StatelessWidget {
  final RegionIdStatusIcon authenticationIdState;

  const AuthenticationStatus({
    super.key,
    required this.authenticationIdState,
  });

  @override
  Widget build(BuildContext context) {
    switch (authenticationIdState) {
      case RegionIdStatusIcon.loading:
        return const CircularProgressIndicator(color: AppColors.green1);
      case RegionIdStatusIcon.valid:
        return const Icon(Icons.check, size: 70, color: AppColors.green1);
      case RegionIdStatusIcon.invalid:
        return const Icon(Icons.block_flipped, size: 70, color: AppColors.red1);
    }
  }
}
