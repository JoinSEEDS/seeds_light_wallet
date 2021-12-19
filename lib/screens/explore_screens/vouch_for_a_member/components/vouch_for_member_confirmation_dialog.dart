import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/vouch_white_background.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_bloc.dart';

class VouchForMemberConfirmationDialog extends StatelessWidget {
  final MemberModel selectedMember;

  const VouchForMemberConfirmationDialog(this.selectedMember, {Key? key}) : super(key: key);

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
            leftButtonTitle: "Cancel",
            rightButtonTitle: "Yes I'm sure",
            onLeftButtonPressed: () {
              Navigator.of(context).pop();
            },
            onRightButtonPressed: () {
              BlocProvider.of<VouchForAMemberBloc>(context).add(OnConfirmVouchForMemberTap());
              Navigator.of(context).pop();
            },
            children: [
              Text('Please read carefully', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10.0),
              Text(
                'Vouching for someone means you are taking responsibility for their actions. If they are flagged, you will also lose reputation points. On the otherhand if they continue progressing to become citizens, you will gain reputation points! Choose carefully!',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Are you sure you would like vouch for ',
                    style: Theme.of(context).textTheme.subtitle2,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${selectedMember.nickname} (${selectedMember.account})',
                          style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
