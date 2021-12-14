import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/vouch_white_background.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_bloc.dart';

class VouchSuccessDialog extends StatelessWidget {
  const VouchSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VouchForAMemberBloc, VouchForAMemberState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            return true;
          },
          child: CustomDialog(
            icon: const CustomPaint(size: Size(60, 60), painter: VouchWhiteBackground()),
            singleLargeButtonTitle: "Close",
            onSingleLargeButtonPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            children: [
              const SizedBox(height: 10.0),
              Text('Successfully Vouched!', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }
}
