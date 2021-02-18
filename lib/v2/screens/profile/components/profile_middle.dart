import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/components/divider_jungle.dart';

// TODO: this is not a list in the ProfileModel should I create a getter that returns a combined skills and interest list of Strings ??
const List<String> skillsAndInterest = ['Weaver', 'Facilitador', 'SharingXP'];

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
            leading: Icon(Icons.location_on_outlined, color: AppColors.springGreen),
            title: Text(
              'Bioregion'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
            trailing: Text(
              'Bali',
              style: Theme.of(context).textTheme.subtitle1HighEmphasis,
            ),
            onTap: () {
              //_chooseCurrencyBottomSheet
            },
          ),
          const DividerJungle(),
          ListTile(
            leading: Icon(Icons.attach_money_sharp, color: AppColors.springGreen),
            title: Text(
              'Currency'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
            trailing: Text(
              'USD',
              style: Theme.of(context).textTheme.subtitle1HighEmphasis,
            ),
            onTap: () {
              NavigationService.of(context).navigateTo(Routes.setCurrency);
            },
          ),
          const DividerJungle(),
          ListTile(
            leading: Icon(
              Icons.favorite_border,
              color: AppColors.springGreen,
            ),
            title: Text(
              'Skills & Interest'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8, // gap between adjacent chips
              runSpacing: 0, // gap between lines
              children: skillsAndInterest
                  .map((i) => Chip(
                        backgroundColor: AppColors.greenfield,
                        label: Text(
                          i,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
