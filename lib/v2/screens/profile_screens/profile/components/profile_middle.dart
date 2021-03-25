import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

/// PROFILE MIDDLE
class ProfileMiddle extends StatelessWidget {
  const ProfileMiddle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on_outlined, color: AppColors.green1),
            title: Text(
              'Region'.i18n,
              style: Theme.of(context).textTheme.button,
            ),
            trailing: Text(
              'Bali',
              style: Theme.of(context).textTheme.headline7,
            ),
            onTap: () {},
          ),
          const DividerJungle(),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.attach_money_sharp, color: AppColors.green1),
                title: Text(
                  'Currency'.i18n,
                  style: Theme.of(context).textTheme.subtitle2HighEmphasis,
                ),
                trailing: Text(
                  settingsStorage.selectedFiatCurrency,
                  style: Theme.of(context).textTheme.subtitle1HighEmphasis,
                ),
                onTap: () async {
                  final res = await NavigationService.of(context).navigateTo(Routes.setCurrency);
                  if (res != null) {
                    BlocProvider.of<ProfileBloc>(context).add(const OnCurrencyChanged());
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
