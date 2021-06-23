import 'package:flutter/material.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/design/app_theme.dart';

class RemoveGuardianConfirmationDialog extends StatelessWidget {
  final GuardianModel guardian;
  final GestureTapCallback? onDismiss;
  final GestureTapCallback? onConfirm;

  const RemoveGuardianConfirmationDialog({
    Key? key,
    this.onConfirm,
    this.onDismiss,
    required this.guardian,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      iconPadding: 0,
      icon: ProfileAvatar(
        size: 80,
        image: guardian.image,
        account: guardian.uid,
        nickname: guardian.nickname,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blue,
        ),
      ),
      children: [
        Text("${guardian.uid}", style: Theme.of(context).textTheme.subtitle2LowEmphasis),
        const SizedBox(height: 30),
        Text("Are you sure you want to remove ${guardian.nickname} \n from your guardians",
            style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center),
        const SizedBox(height: 20),
      ],
      rightButtonTitle: "Confirm",
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Dismiss",
      onLeftButtonPressed: onDismiss,
    );
  }
}
