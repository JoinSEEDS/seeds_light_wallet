import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/string_extension.dart';

class GuardianRowWidget extends StatelessWidget {
  final MemberModel guardianModel;
  final bool showGuardianSigned;

  const GuardianRowWidget({
    Key? key,
    required this.guardianModel,
    required this.showGuardianSigned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: showGuardianSigned ? const Icon(Icons.check_circle, color: AppColors.green) : const SizedBox.shrink(),
        leading: ProfileAvatar(
          size: 60,
          image: guardianModel.image,
          account: guardianModel.account,
          nickname: guardianModel.nickname,
        ),
        title: Text(
          (!guardianModel.nickname.isNullOrEmpty) ? guardianModel.nickname : guardianModel.account,
          style: Theme.of(context).textTheme.button,
        ),
        subtitle: Text(guardianModel.account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
        onTap: () {});
  }
}
