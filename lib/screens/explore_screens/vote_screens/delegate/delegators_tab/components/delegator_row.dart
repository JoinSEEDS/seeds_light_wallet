import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/string_extension.dart';

class DelegatorRow extends StatelessWidget {
  final ProfileModel delegator;

  const DelegatorRow(this.delegator, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileAvatar(
        size: 60,
        image: delegator.image,
        account: delegator.account,
        nickname: delegator.nickname,
      ),
      title: Text(
        (!delegator.nickname.isNullOrEmpty) ? delegator.nickname : delegator.nickname,
        style: Theme.of(context).textTheme.button,
      ),
      subtitle: Text(delegator.account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
    );
  }
}
