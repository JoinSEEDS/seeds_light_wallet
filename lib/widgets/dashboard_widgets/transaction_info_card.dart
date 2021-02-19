import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import '../read_times_tamp.dart';
import '../transaction_avatar.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/read_times_tamp.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class TransactionInfoCard extends StatelessWidget {
  final String ProfileAccount;
  final String ProfileNickname;
  final String ProfileImage;
  final String Timestamp;
  final String Amount;
  final String TypeIcon;
  final GestureTapCallback callback;

  const TransactionInfoCard({
    Key key,
    @required this.Amount,
    @required this.callback,
    @required this.ProfileAccount,
    @required this.ProfileNickname,
    @required this.ProfileImage,
    @required this.Timestamp,
    @required this.TypeIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Ink(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
          child: Row(
            children: <Widget>[
              TransactionAvatar(
                size: 60,
                account: ProfileAccount,
                nickname: ProfileNickname,
                image: ProfileImage,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.jungle,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            ProfileNickname,
                            style: Theme.of(context).textTheme.button,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                          const SizedBox(width: 40),
                          Text(Amount.seedsFormatted, style: Theme.of(context).textTheme.button),
                          const SizedBox(width: 4),
                          SvgPicture.asset(TypeIcon, height: 16)
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(readTimestamp(Timestamp),
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
      ),
    );
  }
}
