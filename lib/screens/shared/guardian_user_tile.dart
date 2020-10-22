import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/firebase/GuardianStatus.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/widgets/transaction_avatar.dart';

Widget guardianUserTile({MemberModel user, GuardianStatus status, GestureTapCallback onTap}) {
  return ListTile(
      trailing: trailingWidget(status, onTap),
      leading: Hero(
        child: TransactionAvatar(
          size: 60,
          image: user.image,
          account: user.account,
          nickname: user.nickname,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
        ),
        tag: "avatar#${user.account}",
      ),
      title: Hero(
        child: Material(
          child: Text(
            user.nickname,
            style: TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w500),
          ),
          color: Colors.transparent,
        ),
        tag: "nickname#${user.account}",
      ),
      subtitle: Hero(
        child: Material(
          child: Text(
            user.account,
            style: TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w400),
          ),
          color: Colors.transparent,
        ),
        tag: "account#${user.account}",
      ),
      onTap: onTap);
}

Widget trailingWidget(GuardianStatus status, GestureTapCallback onTap) {
  switch (status) {
    case GuardianStatus.requestedMe:
      return Wrap(
        children: [
          TextButton(child: Text("Accept", style: TextStyle(color: Colors.green)), onPressed: onTap),
          TextButton(child: Text("Decline", style: TextStyle(color: Colors.red)), onPressed: onTap)
        ],
      );
    case GuardianStatus.requestSent:
      return TextButton(child: Text("Cancel Request", style: TextStyle(color: Colors.red)), onPressed: onTap);
    default:
      return SizedBox.shrink();
  }
}
