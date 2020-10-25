import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/widgets/transaction_avatar.dart';

Widget guardianUserTile({MemberModel user, GuardianStatus status, String currentUserId, Function tileOnTap}) {
  return ListTile(
      trailing: trailingWidget(status, user, currentUserId),
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
      onTap: () {
        tileOnTap(user, status);
      });
}

Widget trailingWidget(GuardianStatus status, MemberModel user, String currentUserId) {
  switch (status) {
    case GuardianStatus.requestedMe:
      return Wrap(
        children: [
          TextButton(
              child: Text("Accept", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                FirebaseDatabaseService().acceptGuardianRequest(
                  currentUserId: currentUserId,
                  friendId: user.account,
                );
              }),
          TextButton(
              child: Text("Decline", style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseDatabaseService().cancelGuardianRequest(
                  currentUserId: currentUserId,
                  friendId: user.account,
                );
              })
        ],
      );
    case GuardianStatus.requestSent:
      return TextButton(
          child: Text("Cancel Request", style: TextStyle(color: Colors.red)),
          onPressed: () {
            FirebaseDatabaseService().cancelGuardianRequest(
              currentUserId: currentUserId,
              friendId: user.account,
            );
          });
    default:
      return SizedBox.shrink();
  }
}
