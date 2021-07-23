import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

/// PROFILE MIDDLE
class ProfileMiddle extends StatelessWidget {
  const ProfileMiddle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ListTile(
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(
                  'assets/images/profile/contribution_icon.svg',
                ),
                title: Text(
                  'Contribution Score'.i18n,
                  style: Theme.of(context).textTheme.button,
                ),
                trailing: Text(
                  '${state.score?.contributionScore?.value ?? '00'}/99',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline7LowEmphasis,
                ),
                onTap: () {
                  NavigationService.of(context).navigateTo(Routes.contribution, state.score);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: DividerJungle(thickness: 2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ListTile(
                horizontalTitleGap: 0,
                leading: const Icon(Icons.attach_money_sharp, color: AppColors.green1),
                title: Text(
                  'Currency'.i18n,
                  style: Theme.of(context).textTheme.button,
                ),
                trailing: Text(
                  settingsStorage.selectedFiatCurrency,
                  style: Theme.of(context).textTheme.headline7,
                ),
                onTap: () async {
                  final res = await NavigationService.of(context).navigateTo(Routes.setCurrency);
                  if (res != null) {
                    BlocProvider.of<ProfileBloc>(context).add(const OnCurrencyChanged());
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
