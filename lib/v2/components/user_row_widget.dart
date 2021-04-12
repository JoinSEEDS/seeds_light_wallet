import 'package:flutter/material.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class UserRowWidget extends StatelessWidget {
  final String imageUrl;
  final String account;
  final String name;
  final String toOrFromText;

  const UserRowWidget({Key key, this.imageUrl, this.account, this.name, this.toOrFromText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.buttonBlack),
                const SizedBox(height: 8),
                Text(account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack)
              ],
            ),
          ),
        ),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(4, 4)), color: AppColors.lightGreen5),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
              child: Text(toOrFromText, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            )),
      ],
    );
  }
}