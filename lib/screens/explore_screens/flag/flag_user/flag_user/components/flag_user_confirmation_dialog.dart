import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/vouch_white_background.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/interactor/viewmodel/flag_user_bloc.dart';

class FlagUserConfirmationDialog extends StatelessWidget {
  const FlagUserConfirmationDialog({Key? key}) : super(key: key);

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
            icon: const CustomPaint(size: Size(60, 60), painter: VouchWhiteBackground()),
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Yes I'm sure",
            onLeftButtonPressed: () {
              Navigator.of(context).pop();
            },
            onRightButtonPressed: () {
              BlocProvider.of<FlagUserBloc>(context).add(OnConfirmFlagUserTap());
              Navigator.of(context).pop();
            },
            children: [
              Text('Please read carefully', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10.0),
              Text(
                'Vouching for someone means you are taking responsibility for their actions. If they are flagged, you will also lose reputation points. On the other hand, if they continue progressing to become citizens, you will gain reputation points! Choose carefully!',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Are you sure you would like to vouch for ',
                    style: Theme.of(context).textTheme.subtitle2,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${state.selectedProfile?.nickname} (${state.selectedProfile?.account})',
                          style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis),
                      TextSpan(text: '?', style: Theme.of(context).textTheme.subtitle2),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
