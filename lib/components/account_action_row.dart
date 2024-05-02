import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/design/app_theme.dart';

class AccountActionRow extends StatelessWidget {
  final String image;
  final String account;
  final String nickname;
  final Widget? action;
  final GestureTapCallback? onTileTap;

  const AccountActionRow({
    super.key,
    required this.image,
    required this.account,
    required this.nickname,
    this.action,
    this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: onTileTap,
        child: Row(
          children: [
            ProfileAvatar(
              size: 60,
              image: image,
              account: account,
              nickname: nickname,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            nickname.isNotEmpty ? nickname : account,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                  ],
                ),
              ),
            ),
            action ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
