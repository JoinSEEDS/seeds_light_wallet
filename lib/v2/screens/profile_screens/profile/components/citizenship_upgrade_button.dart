import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';
import 'package:seeds/v2/design/app_theme.dart';

class CitizenshipUpgradeButton extends StatelessWidget {
  final CitizenshipUpgradeStatus citizenshipUpgradeStatus;

  const CitizenshipUpgradeButton(this.citizenshipUpgradeStatus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (citizenshipUpgradeStatus) {
      case CitizenshipUpgradeStatus.canResident:
        return MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: AppColors.darkGreen2,
          padding: const EdgeInsets.all(8.0),
          //Next Pr
          onPressed: () {},
          child: Text(
            'Upgrade To Resident',
            style: Theme.of(context).textTheme.subtitle3,
          ),
        );

      case CitizenshipUpgradeStatus.canCitizen:
        return MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: AppColors.darkGreen2,
          padding: const EdgeInsets.all(8.0),
          //Next Pr
          onPressed: () {},
          child: Text(
            'Upgrade To Citizen',
            style: Theme.of(context).textTheme.subtitle3,
          ),
        );

      case CitizenshipUpgradeStatus.notReady:
        return const SizedBox.shrink();
    }
  }
}
