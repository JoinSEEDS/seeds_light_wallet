import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/transaction_avatar.dart';

class AtmSeller extends StatelessWidget {
  
  final MemberModel member;
  final Color color;

  AtmSeller({Key key, this.member, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final relativePadding = width * 0.05;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      padding: EdgeInsets.only(top: 7, bottom: 7, left: 7 + relativePadding, right: 7 + relativePadding),
      child: Row(
        children: <Widget>[
          TransactionAvatar(
            size: 40,
            account: member.account,
            nickname: member.nickname,
            image: member.image,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue,
            ),
          ),
          Text(member.nickname),
          MainButton(

            //margin: EdgeInsets.only(top: 25),
            title: 'BUY',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}