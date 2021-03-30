import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';

class SendTransactionSuccessDialog extends StatelessWidget {
  final String amount;
  final String toImage;
  final String toName;
  final String toAccount;
  final String fromImage;
  final String fromName;
  final String fromAccount;

  const SendTransactionSuccessDialog({
    Key key,
    this.amount,
    this.toImage,
    this.toName,
    this.toAccount,
    this.fromImage,
    this.fromName,
    this.fromAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const Icon(Icons.fingerprint, size: 52, color: AppColors.green1),
      children: [
        Text(
          amount,
          style: Theme.of(context).textTheme.headline6.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 16.0),
        ListTile(
          leading: ProfileAvatar(
            size: 60,
            image: toImage,
            account: toAccount,
            nickname: toName,
          ),
          title: Text(
            toName,
            style: Theme.of(context).textTheme.button.copyWith(color: AppColors.primary),
          ),
          subtitle: Text(
            toAccount,
            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis.copyWith(color: AppColors.primary),
          ),
          trailing: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(4, 4)), color: AppColors.lightGreen5),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                child: Text(
                  'To',
                  style: Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.primary),
                ),
              )),
        ),
        ListTile(
          leading: ProfileAvatar(
            size: 60,
            image: fromImage,
            account: fromAccount,
            nickname: fromName,
          ),
          title: Text(
            fromName,
            style: Theme.of(context).textTheme.button.copyWith(color: AppColors.primary),
          ),
          subtitle: Text(
            fromAccount,
            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis.copyWith(color: AppColors.primary),
          ),
          trailing: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(4, 4)), color: AppColors.lightGreen5),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                child: Text(
                  'From',
                  style: Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.primary),
                ),
              )),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Text(
              'Date:  ',
              style: Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.primary),
            ),
            Text(
              DateFormat('dd-MMMM-yyyy - HH:mm:ss').format(DateTime.now()),
              style: Theme.of(context).textTheme.subtitle2LowEmphasis.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Transaction ID:  ',
              style: Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.primary),
            ),
            Expanded(
              child: Text(
                "KDKKFKFJJDKKDKFJJFJKKDK",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2LowEmphasis.copyWith(color: AppColors.primary),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.copy),
                color: AppColors.primary,
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: 'KDKKFKFJJDKKDKFJJFJKKDK')).then(
                    (value) {
                      Scaffold.of(context).showSnackBar(const SnackBar(
                        content: Text("Copied"),
                        duration: Duration(seconds: 1),
                      ));
                    },
                  );
                })
          ],
        ),
        Row(
          children: [
            Text(
              'Status:  ',
              style: Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.primary),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.lightGreen5),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                child: Text(
                  "Successful",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2LowEmphasis.copyWith(color: AppColors.green1),
                ),
              ),
            ),
          ],
        ),
      ],
      singleLargeButtonTitle: 'Close',
    );
  }
}
