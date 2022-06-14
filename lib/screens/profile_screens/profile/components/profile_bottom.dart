import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/citizenship_card.dart';
import 'package:seeds/screens/profile_screens/profile/components/citizenship_upgrade_in_progress_dialog.dart';
import 'package:seeds/screens/profile_screens/profile/components/citizenship_upgrade_success_dialog.dart';
import 'package:seeds/screens/profile_screens/profile/components/logout_dialog.dart';
import 'package:seeds/screens/profile_screens/profile/components/logout_recovery_phrase_dialog.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_list_tile_card.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class ProfileBottom extends StatelessWidget {
  const ProfileBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) {
        final pageCommand = state.pageCommand;
        BlocProvider.of<ProfileBloc>(context).add(const ClearProfilePageCommand());
        if (pageCommand is ShowLogoutDialog) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<ProfileBloc>(context),
                child: const LogoutDialog(),
              );
            },
          ).whenComplete(() => BlocProvider.of<ProfileBloc>(context).add(const ResetShowLogoutButton()));
        } else if (pageCommand is ShowLogoutRecoveryPhraseDialog) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<ProfileBloc>(context),
                child: const LogoutRecoveryPhraseDialog(),
              );
            },
          ).whenComplete(() => BlocProvider.of<ProfileBloc>(context).add(const ResetShowLogoutButton()));
        } else if (pageCommand is ShowCitizenshipUpgradeSuccess) {
          Navigator.pop(context, CitizenshipUpgradeInProgressDialog);
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<ProfileBloc>(context),
                child: CitizenshipUpgradeSuccessDialog(isResident: pageCommand.isResident),
              );
            },
          );
        } else if (pageCommand is ShowProcessingCitizenshipUpgrade) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<ProfileBloc>(context),
                child: const CitizenshipUpgradeInProgressDialog(),
              );
            },
          );
        } else if (pageCommand is ShowErrorMessage) {
          Navigator.pop(context, CitizenshipUpgradeInProgressDialog);
          eventBus.fire(ShowSnackBar(pageCommand.message));
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
                return ProfileListTileCard(
                  hasNotification: state.hasSecurityNotification,
                  leadingIcon: Icons.verified_user_outlined,
                  title: 'Security'.i18n,
                  trailing: const Icon(Icons.arrow_forward_ios_sharp),
                  onTap: () => NavigationService.of(context).navigateTo(Routes.security),
                );
              },
            ),
            const SizedBox(height: 8.0),
            ProfileListTileCard(
              leadingIcon: Icons.support,
              title: 'Support'.i18n,
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () => NavigationService.of(context).navigateTo(Routes.support),
            ),
            const SizedBox(height: 120.0),
            ProfileListTileCard(
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
