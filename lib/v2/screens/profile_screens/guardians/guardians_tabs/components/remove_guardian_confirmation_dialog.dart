import 'package:flutter/material.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';

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
        const SizedBox(height: 20),
        Text("Remove Guardian?", style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text("Are you sure you want to remove ${guardian.nickname} as your Guardian?",
              style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 20),
      ],
      rightButtonTitle: "Accept",
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Decline",
      onLeftButtonPressed: onDismiss,
    );
  }
}
