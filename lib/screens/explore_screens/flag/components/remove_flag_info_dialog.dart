import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_bloc.dart';

class RemoveFlagInfoDialog extends StatelessWidget {
  final String userAccount;

  const RemoveFlagInfoDialog(this.userAccount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      leftButtonTitle: 'Cancel'.i18n,
      rightButtonTitle: 'Yes, Remove'.i18n,
      onLeftButtonPressed: () {
        Navigator.of(context).pop();
      },
      onRightButtonPressed: () {
        BlocProvider.of<FlagBloc>(context).add(OnRemoveUserFlagTapped(userAccount));
        Navigator.of(context).pop();
      },
      icon: SvgPicture.asset("assets/images/profile/logout_icon.svg"),
      children: [
        Text('Are you sure?', style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Text(
                'Removing the Flag means you believe the member is now acting in good faith. Penalties will be removed from the member. ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
            ],
          ),
        ),
      ],
    );
  }
}
