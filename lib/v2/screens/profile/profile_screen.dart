import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/screens/profile/components/profile_bottom.dart';
import 'package:seeds/v2/screens/profile/components/profile_header.dart';
import 'package:seeds/v2/screens/profile/components/profile_middle.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile(userName: 'raul11111111')),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          switch (state.pageState) {
            case PageState.initial:
              return const SizedBox.shrink();
            case PageState.loading:
              return Container(child: const Center(child: CircularProgressIndicator()));
            case PageState.failure:
              return Container(child: const Center(child: Text('Error:')));
            case PageState.success:
              return ListView(
                children: <Widget>[
                  const ProfileHeader(),
                  const DividerJungle(thickness: 2),
                  const ProfileMiddle(),
                  const DividerJungle(thickness: 2),
                  const ProfileBottom(),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
