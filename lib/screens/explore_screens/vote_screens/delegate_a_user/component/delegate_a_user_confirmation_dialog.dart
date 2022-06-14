import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_bloc.dart';

class DelegateAUserConfirmationDialog extends StatelessWidget {
  final ProfileModel selectedDelegate;

  const DelegateAUserConfirmationDialog(this.selectedDelegate, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegateAUserBloc, DelegateAUserState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            return true;
          },
          child: CustomDialog(
            icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Yes I'm sure",
            onRightButtonPressed: () {
              BlocProvider.of<DelegateAUserBloc>(context).add(OnConfirmDelegateTab(selectedDelegate));
              Navigator.of(context).pop();
            },
            children: [
              Text('Delegate Confirmation', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 30.0),
              Text(
                  'By selecting this Citizen as your delegate you are entrusting your Trust Tokens to them to vote with.',
                  style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(height: 20.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Are you sure you would like ',
                    style: Theme.of(context).textTheme.subtitle2,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${selectedDelegate.nickname} (${selectedDelegate.account})',
                          style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis),
                      TextSpan(text: ' to be your delegate?', style: Theme.of(context).textTheme.subtitle2)
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
