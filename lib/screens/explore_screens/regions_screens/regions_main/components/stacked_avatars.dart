import 'package:flutter/material.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_colors.dart';

class StackedAvatars extends StatelessWidget {
  final List<ProfileModel> profiles;
  final double avatarSize;

  const StackedAvatars(this.profiles, this.avatarSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overlap = avatarSize / 2;
    final items = profiles
        .map((i) => ProfileAvatar(
              size: avatarSize,
              account: i.account,
              nickname: i.nickname,
              image: i.image,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGreen2),
            ))
        .toList();

    return Stack(
      children: List<Widget>.generate(
        items.length,
        (index) => Padding(padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0), child: items[index]),
      ),
    );
  }
}
