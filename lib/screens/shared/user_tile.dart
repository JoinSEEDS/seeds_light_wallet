import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/v2/screens/dashboard/components/transaction_avatar.dart';

Widget userTile({required MemberModel user, bool selected = false, GestureTapCallback? onTap}) {
  return ListTile(
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : const SizedBox.shrink(),
      leading: Hero(
        child: TransactionAvatar(
          size: 60,
          image: user.image,
          account: user.account,
          nickname: user.nickname,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
        ),
        tag: "avatar#${user.account}",
      ),
      title: Hero(
        child: Material(
          child: Text(
            user.nickname!,
            style: const TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w500),
          ),
          color: Colors.transparent,
        ),
        tag: "nickname#${user.account}",
      ),
      subtitle: Hero(
        child: Material(
          child: Text(
            user.account!,
            style: const TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w400),
          ),
          color: Colors.transparent,
        ),
        tag: "account#${user.account}",
      ),
      onTap: onTap);
}
