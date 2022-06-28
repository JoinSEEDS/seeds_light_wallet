import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

enum RegionIdStatusIcon { loading, valid, invalid }

class AuthenticationStatus extends StatelessWidget {
  const AuthenticationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: BlocBuilder<CreateRegionBloc, CreateRegionState>(
        buildWhen: (previous, current) => previous.regionIdValidationStatus != current.regionIdValidationStatus,
        builder: (context, state) {
          switch (state.regionIdValidationStatus) {
            case RegionIdStatusIcon.loading:
              return const CircularProgressIndicator(color: AppColors.green1);
            case RegionIdStatusIcon.valid:
              return const Icon(Icons.check, size: 70, color: AppColors.green1);
            case RegionIdStatusIcon.invalid:
              return const Icon(Icons.block_flipped, size: 70, color: AppColors.red1);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
