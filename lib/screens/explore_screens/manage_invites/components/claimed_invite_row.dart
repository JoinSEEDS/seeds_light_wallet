import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';

class ClaimedInviteRow extends StatelessWidget {
  final String? imageUrl;
  final String account;
  final String? name;
  final ProfileStatus? status;
  final GestureTapCallback? resultCallBack;

  const ClaimedInviteRow({
    super.key,
    this.imageUrl,
    required this.account,
    this.name,
    this.resultCallBack,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: InkWell(
        onTap: resultCallBack,
        child: Row(
          children: [
            ProfileAvatar(
              size: 60,
              image: imageUrl,
              account: account,
              nickname: name,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (name != null && name?.isNotEmpty == true) ? name! : account,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                  ],
                ),
              ),
            ),
            Text(status?.name ?? ''),
          ],
        ),
      ),
    );
  }
}
