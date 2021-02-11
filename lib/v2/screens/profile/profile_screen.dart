import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/screens/profile/components/profile_bottom.dart';
import 'package:seeds/v2/screens/profile/components/profile_header.dart';
import 'package:seeds/v2/screens/profile/components/profile_middle.dart';
import 'package:seeds/v2/screens/profile/interactor/profile_bloc.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/events.dart';

/// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile(userName: "raul11111111")),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: ListView(
          children: <Widget>[
            const ProfileHeader(),
            const Divider(color: AppColors.jungle, thickness: 2),
            const ProfileMiddle(),
            const Divider(color: AppColors.jungle, thickness: 2),
            const ProfileBottom(),
          ],
        ),
      ),
    );
  }
}
