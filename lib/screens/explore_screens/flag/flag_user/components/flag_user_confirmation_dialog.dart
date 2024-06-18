import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/interactor/viewmodel/flag_user_bloc.dart';

class FlagUserConfirmationDialog extends StatelessWidget {
  const FlagUserConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlagUserBloc, FlagUserState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            return true;
          },
          child: CustomDialog(
            icon: const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
            leftButtonTitle: 'Back',
            rightButtonTitle: "Yes I'm sure",
            onRightButtonPressed: () {
              BlocProvider.of<FlagUserBloc>(context).add(OnConfirmFlagUserTap());
              Navigator.of(context).pop();
            },
            children: [
              Text('Are you sure?', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10.0),
              Text(
                'Flagging has strong negative consequences so please make sure you are flagging the right person!',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Are you sure you would like to flag ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${state.selectedProfile?.nickname} (${state.selectedProfile?.account})',
                          style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis),
                      TextSpan(text: '?', style: Theme.of(context).textTheme.titleSmall),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
