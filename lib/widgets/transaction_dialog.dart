import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:share/share.dart';

class TransactionDialog extends StatefulWidget {
  final TransactionModel transaction;
  final MemberModel member;
  final TransactionType transactionType;

  TransactionDialog({this.transaction, this.member, this.transactionType});

  @override
  TransactionDialogState createState() => TransactionDialogState();
}

class TransactionDialogState extends State<TransactionDialog> {
  @override
  void initState() {
    super.initState();
  }

  void onShare() {
    final transactionId = widget.transaction.transactionId;
    final transactionLink = "https://telos.bloks.io/transaction/$transactionId";

    Share.share(transactionLink);
  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final imageUrl = widget.member.image;
    final fullName = widget.member.nickname;
    final time = DateTime.tryParse(widget.transaction.timestamp).toString();

    return Stack(children: [
      Container(
        height: 70, //width * 0.2,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.gradient),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      ),
      Container(
        width: width,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 12), //width * 0.04),
        child: Text(
          time,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 35), //width * 0.1),
          width: width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                  width: 70, //width * 0.19,
                  height: 70, //width * 0.19,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                      border: Border.all(color: Colors.white, width: 5)),
                  child: imageUrl != null
                      ? CachedNetworkImage(imageUrl: imageUrl)
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            fullName.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                        ))))
    ]);
  }

  Widget buildButton(String title, String asset, Function onTap) {
    return InkWell(
        onTap: onTap,
        child: Column(children: [
          Container(
            width: 65, //width * 0.13,
            height: 65, //width * 0.13,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: AppColors.gradient)),
            padding: EdgeInsets.all(18),
            child: SvgPicture.asset(asset),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.blue, fontSize: 15),
          )
        ]));
  }

  Widget buildContent() {
    final fullName = widget.member.nickname;
    final type = widget.transactionType;
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 2),
              child: Text(
                fullName,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Container(
              child: Text(
                widget.transaction.from,
                maxLines: 1,
                style: TextStyle(color: AppColors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  type == TransactionType.income ? '+ ' : '-',
                  style: TextStyle(
                    color: type == TransactionType.income
                        ? AppColors.green
                        : AppColors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.transaction.quantity,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                )
              ],
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildButton('Share receipt', 'assets/images/share.svg', onShare),
          ],
        ),
        Padding(padding: EdgeInsets.only())
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [buildHeader(), buildContent()],
      ),
    );
  }
}
