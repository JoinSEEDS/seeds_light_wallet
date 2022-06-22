import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';

class RemoveGuardianConfirmationDialog extends StatelessWidget {
  final GuardianModel guardian;
  final GestureTapCallback? onDismiss;
  final GestureTapCallback? onConfirm;

  const RemoveGuardianConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onDismiss,
    required this.guardian,
  });

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
      rightButtonTitle: "Ok".i18n,
      onRightButtonPressed: onConfirm,
      leftButtonTitle: "Cancel".i18n,
      onLeftButtonPressed: onDismiss,
      children: [
        const SizedBox(height: 20),
        Text("Remove Guardian?".i18n, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Are you sure you want to remove '.i18n,
                style: Theme.of(context).textTheme.subtitle2,
                children: <TextSpan>[
                  TextSpan(text: guardian.nickname, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(text: ' as your Guardian?'.i18n, style: Theme.of(context).textTheme.subtitle2)
                ]),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
