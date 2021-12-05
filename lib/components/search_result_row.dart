import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/cap_utils.dart';

class SearchResultRow extends StatelessWidget {
  final MemberModel member;
  final GestureTapCallback? onTap;

  const SearchResultRow({Key? key, required this.member, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ProfileAvatar(
              size: 60,
              image: member.image,
              account: member.account,
              nickname: member.nickname,
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
                        Text(
                          member.nickname.isNotEmpty ? member.nickname : member.account,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.button,
                        ),
                        Text(
                          describeEnum(member.userCitizenshipStatus).inCaps,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(member.account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
