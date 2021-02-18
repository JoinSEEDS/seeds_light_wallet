import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/settings.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/settings/components/settings_card.dart';

// TODO(raul): this is not a list in the ProfileModel should I create a getter that returns a combined skills and interest list of Strings ??
const List<String> skillsAndInterest = ['Weaver', 'Facilitador', 'SharingXP'];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'.i18n), elevation: 0.0),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingsCard(
            icon: Icons.person_outline,
            title: 'Display Name'.i18n,
            titleValue: 'Raul Urtecho',
            descriptionText: 'Set your Display Name so that others can recognize your account.'.i18n,
            route: Routes.editName,
          ),
          SettingsCard(
            icon: Icons.location_on_outlined,
            title: 'Bioregion'.i18n,
            titleValue: 'Bali',
            descriptionText: 'Join or create a bioregion to become active in your local community!'.i18n,
          ),
          SettingsCard(
            icon: Icons.attach_money_sharp,
            title: 'Currency'.i18n,
            titleValue: 'USD',
            descriptionText:
                'Setting your local currency lets you easily switch between your local and preferred currency.'.i18n,
          ),
          SettingsCard(
            icon: Icons.favorite_border,
            title: 'Skills & Interest'.i18n,
            descriptionWidget: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 5, // gap between adjacent chips
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
          ),
        ],
      ),
    );
  }
}
