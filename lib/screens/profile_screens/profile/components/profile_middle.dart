import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_list_tile.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class ProfileMiddle extends StatelessWidget {
  const ProfileMiddle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            ProfileListTile(
              showShimmer: state.showShimmer,
              leading: SvgPicture.asset('assets/images/profile/contribution_icon.svg'),
              title: 'Contribution Score'.i18n,
              trailing: '${state.contributionScore?.value ?? '00'}/99',
              onTap: () {
                NavigationService.of(context).navigateTo(Routes.contribution);
              },
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: DividerJungle(thickness: 2)),
            ProfileListTile(
              leading: const Icon(Icons.attach_money_sharp, color: AppColors.green1),
              title: 'Currency'.i18n,
              trailing: settingsStorage.selectedFiatCurrency,
              onTap: () async {
                final bool? shouldRebuild = await NavigationService.of(context).navigateTo(Routes.setCurrency);
                if (shouldRebuild != null && shouldRebuild) {
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<ProfileBloc>(context).add(const OnCurrencyChanged());
                }
              },
            ),
          ],
        );
      },
    );
  }
}
