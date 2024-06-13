import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_bloc.dart';

class RemoveDelegateConfirmationDialog extends StatelessWidget {
  const RemoveDelegateConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: const Icon(Icons.cancel_outlined, size: 60, color: AppColors.red),
        leftButtonTitle: "Cancel",
        rightButtonTitle: "Yes, I'm sure",
        onRightButtonPressed: () {
          BlocProvider.of<DelegatesBloc>(context).add(const RemoveDelegate());
          Navigator.of(context).pop();
        },
        children: [
          const SizedBox(height: 10.0),
          Text('Remove Delegate?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 30.0),
          Text('Are you sure you would like to remove this person as your Delegate?',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
