import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class CitizenshipUpgradeButton extends StatelessWidget {
  final CitizenshipUpgradeStatus citizenshipUpgradeStatus;
  final VoidCallback onPressed;

  const CitizenshipUpgradeButton({super.key, required this.citizenshipUpgradeStatus, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    switch (citizenshipUpgradeStatus) {
      case CitizenshipUpgradeStatus.canResident:
        return MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: AppColors.darkGreen2,
          padding: const EdgeInsets.all(8.0),
          onPressed: onPressed,
          child: Text('Upgrade To Resident'.i18n, style: Theme.of(context).textTheme.subtitle3),
        );

      case CitizenshipUpgradeStatus.canCitizen:
        return MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: AppColors.darkGreen2,
          padding: const EdgeInsets.all(8.0),
          onPressed: onPressed,
          child: Text('Upgrade To Citizen'.i18n, style: Theme.of(context).textTheme.subtitle3),
        );

      case CitizenshipUpgradeStatus.notReady:
        return const SizedBox.shrink();
    }
  }
}
