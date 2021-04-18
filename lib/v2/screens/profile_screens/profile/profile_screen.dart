import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/constants/app_colors.dart';

import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/profile_bottom.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/profile_header.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/profile_middle.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

/// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileValues()),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Scaffold(
                  appBar: AppBar(
                    title: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
                      return DropdownButton<bool>(
                        value: true,
                        icon: const Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.white),
                        underline: const SizedBox.shrink(),
                        hint: Text(state.profile?.account ?? '', style: Theme.of(context).textTheme.headline6),
                        items: [],
                        onTap: () {
                          // For the onTap to work there must be at least one item.
                        },
                      );
                    }),
                    actions: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/wallet/app_bar/scan_qr_code_icon.svg',
                          height: 30,
                          width: 2000,
                        ),
                        onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
                      ),
                    ],
                  ),
                  body: ListView(
                    children: <Widget>[
                      const ProfileHeader(),
                      const DividerJungle(thickness: 2),
                      const ProfileMiddle(),
                      const DividerJungle(thickness: 2),
                      const ProfileBottom(),
                    ],
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
