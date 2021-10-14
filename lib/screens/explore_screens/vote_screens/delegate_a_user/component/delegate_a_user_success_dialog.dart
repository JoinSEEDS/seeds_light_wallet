import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/delegate_a_user_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_state.dart';

class DelegateAUserSuccessDialog extends StatelessWidget {
  const DelegateAUserSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegateAUserBloc, DelegateAUserState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return true;
        },
        child: CustomDialog(
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: "Dismiss",
          onSingleLargeButtonPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          children: [
            Text('Delegate Chosen!', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 30.0),
            Text('You have successfully chosen your delegate. They will now vote with the power of your vote.',
                style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
      );
    });
  }
}
