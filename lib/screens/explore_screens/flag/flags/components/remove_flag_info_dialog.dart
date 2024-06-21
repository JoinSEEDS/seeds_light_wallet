import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/viewmodels/flag_bloc.dart';

class RemoveFlagInfoDialog extends StatelessWidget {
  final String userAccount;

  const RemoveFlagInfoDialog(this.userAccount, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      leftButtonTitle: 'Back',
      rightButtonTitle: "Yes I'm sure",
      onRightButtonPressed: () {
        BlocProvider.of<FlagBloc>(context).add(OnRemoveUserFlagTapped(userAccount));
        Navigator.of(context).pop();
      },
      icon: const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
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
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ],
    );
  }
}
