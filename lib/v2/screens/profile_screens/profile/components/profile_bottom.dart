import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/card_list_tile.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/logout_dialog.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';

import 'citizenship_card.dart';

/// PROFILE BOTTOM
class ProfileBottom extends StatelessWidget {
  const ProfileBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) {
        var pageCommand = state.pageCommand;

        if (pageCommand is ShowLogoutDialog) {
          BlocProvider.of<ProfileBloc>(context).add(const ClearShowLogoutDialog());
          showDialog<void>(
            context: context,
            builder: (_) {
              return BlocProvider.value(value: BlocProvider.of<ProfileBloc>(context), child: const LogoutDialog());
            },
          ).whenComplete(() => BlocProvider.of<ProfileBloc>(context).add(const ResetShowLogoutButton()));
        } else if (pageCommand is ShowCitizenshipUpgradeSuccess) {
          //Todo Next Pr
        } else if (pageCommand is ShowErrorMessage) {
          //Todo Next PR
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CitizenshipCard(),
            const SizedBox(height: 16.0),
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) => previous.hasSecurityNotification != current.hasSecurityNotification,
              builder: (context, state) {
                return CardListTile(
                  hasNotification: state.hasSecurityNotification,
                  leadingIcon: Icons.verified_user_outlined,
                  title: 'Security'.i18n,
                  trailing: const Icon(Icons.arrow_forward_ios_sharp),
                  onTap: () => NavigationService.of(context).navigateTo(Routes.security),
                );
              },
            ),
            const SizedBox(height: 8.0),
            CardListTile(
              leadingIcon: Icons.support,
              title: 'Support'.i18n,
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () => NavigationService.of(context).navigateTo(Routes.support),
            ),
            const SizedBox(height: 120.0),
            CardListTile(
              leadingIcon: Icons.logout,
              title: 'Logout'.i18n,
              trailing: const SizedBox.shrink(),
              onTap: () => BlocProvider.of<ProfileBloc>(context).add(const OnProfileLogoutButtonPressed()),
            ),
            const SizedBox(height: 26.0),
          ],
        ),
      ),
    );
  }
}
