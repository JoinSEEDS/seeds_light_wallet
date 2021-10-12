import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/design/app_theme.dart';

class DelegateRow extends StatelessWidget {
  final String account;
  final String nickname;
  final VoidCallback onTapRemove;

  const DelegateRow({Key? key, required this.account, required this.nickname, required this.onTapRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(size: 40, account: account, nickname: nickname),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delegated to',
                    textAlign: TextAlign.start, style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
                const SizedBox(height: 2),
                Text(account, style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis)
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: onTapRemove,
            child: Text("Remove", style: Theme.of(context).textTheme.subtitle3OpacityEmphasisRed))
      ],
    );
  }
}
