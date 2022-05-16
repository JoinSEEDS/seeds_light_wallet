import 'package:flutter/material.dart';
import 'package:seeds/design/app_theme.dart';

class UnClaimedInviteRow extends StatelessWidget {
  final String amount;
  final String inviteHex;
  final GestureTapCallback cancelCallback;

  const UnClaimedInviteRow({
    super.key,
    required this.amount,
    required this.inviteHex,
    required this.cancelCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(amount),
      title: Text(
        inviteHex,
        style: Theme.of(context).textTheme.subtitle3,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: TextButton(
        onPressed: cancelCallback,
        child: Text("Cancel Invite", style: Theme.of(context).textTheme.subtitle3Red),
      ),
    );
  }
}
