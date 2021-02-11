import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/screens/explore/interactor/explore_bloc.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/events.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc()..add(LoadExplore(userName: "raul11111111")),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: ListView(
          children: <Widget>[
            // const ProfileHeader(),
            // const Divider(color: AppColors.jungle, thickness: 2),
            // const ProfileMiddle(),
            // const Divider(color: AppColors.jungle, thickness: 2),
            // const ProfileBottom(),
          ],
        ),
      ),
    );
  }
}
