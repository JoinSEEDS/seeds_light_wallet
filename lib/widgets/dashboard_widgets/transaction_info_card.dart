import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import '../read_times_tamp.dart';
import '../transaction_avatar.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/read_times_tamp.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class TransactionInfoCard extends StatelessWidget {
  final String transactionProfileAccount;
  final String transactionProfileNickname;
  final String transactionProfileImage;
  final String transactionTimestamp;
  final String transactionAmount;
  final String transactionTypeIcon;
  final GestureTapCallback callback;

  const TransactionInfoCard({
    Key key,
    @required this.transactionAmount,
    @required this.callback,
    @required this.transactionProfileAccount,
    @required this.transactionProfileNickname,
    @required this.transactionProfileImage,
    @required this.transactionTimestamp,
    @required this.transactionTypeIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        child: Row(
          children: <Widget>[
            TransactionAvatar(
              size: 60,
              account: transactionProfileAccount,
              nickname: transactionProfileNickname,
              image: transactionProfileImage,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          transactionProfileNickname,
                          style: Theme.of(context).textTheme.button,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                        SizedBox(width: 40),
                        Text(transactionAmount.seedsFormatted, style: Theme.of(context).textTheme.button),
                        SizedBox(width: 4),
                        SvgPicture.asset(transactionTypeIcon, height: 16)
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(readTimestamp(transactionTimestamp),
                                style: Theme.of(context).textTheme.subtitle2)),
                        Text('SEEDS'.i18n, style: Theme.of(context).textTheme.subtitle2)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
