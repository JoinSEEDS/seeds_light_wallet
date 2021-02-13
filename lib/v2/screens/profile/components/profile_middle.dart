import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';

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
          Divider(color: AppColors.jungle),
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
              //_chooseCurrencyBottomSheet
            },
          ),
          Divider(color: AppColors.jungle),
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
                        backgroundColor: AppColors.jungle,
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
