import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';

class MemberInfoRow extends StatelessWidget {
  final ProfileModel member;

  const MemberInfoRow(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                      Flexible(
                        child: Text(
                          member.nickname.isNotEmpty ? member.nickname : member.account,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Text(
                        member.statusString,
                        style: Theme.of(context).textTheme.labelLarge,
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
    );
  }
}
