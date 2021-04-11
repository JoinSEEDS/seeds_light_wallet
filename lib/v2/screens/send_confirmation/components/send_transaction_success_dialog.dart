import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';

class SendTransactionSuccessDialog extends StatelessWidget {
  final String amount;
  final String fiatAmount;
  final String toImage;
  final String toName;
  final String toAccount;
  final String fromImage;
  final String fromName;
  final String fromAccount;
  final String transactionID;

  const SendTransactionSuccessDialog(
      {Key key,
      @required this.amount,
      this.fiatAmount,
      this.toImage,
      this.toName,
      @required this.toAccount,
      this.fromImage,
      this.fromName,
      @required this.fromAccount,
      @required this.transactionID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      children: [
        Row(
          children: [
            Text(amount.split(' ')[0], style: Theme.of(context).textTheme.headline4Black),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Text(amount.split(' ')[1], style: Theme.of(context).textTheme.subtitle2Black),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Text(fiatAmount ?? "", style: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack),
        const SizedBox(height: 16.0),
        DialogRow(imageUrl: toImage, account: toAccount, name: toName, toOrFromText: "To"),
        const SizedBox(height: 16.0),
        DialogRow(imageUrl: fromImage, account: fromAccount, name: fromName, toOrFromText: "From"),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Text('Date:  ', style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            Text(
              DateFormat('dd-MMMM-yyyy - K:MM a').format(DateTime.now()),
              style: Theme.of(context).textTheme.subtitle2BlackLowEmphasis,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Transaction ID:  ', style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            Expanded(
              child: Text(
                transactionID,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2BlackLowEmphasis,
              ),
            ),
            IconButton(
                icon: const Icon(Icons.copy),
                color: AppColors.primary,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: transactionID)).then(
                    (value) {
                      ScaffoldMessenger.maybeOf(context)
                          .showSnackBar(const SnackBar(content: Text("Copied"), duration: Duration(seconds: 1)));
                    },
                  );
                })
          ],
        ),
        Row(
          children: [
            Text('Status:  ', style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.lightGreen5),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                child: Text(
                  "Successful",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2HighEmphasisGreen1,
                ),
              ),
            ),
          ],
        ),
      ],
      onSingleLargeButtonPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      singleLargeButtonTitle: 'Close',
    );
  }
}

class DialogRow extends StatelessWidget {
  final String imageUrl;
  final String account;
  final String name;
  final String toOrFromText;

  const DialogRow({Key key, this.imageUrl, this.account, this.name, this.toOrFromText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileAvatar(
          size: 60,
          image: imageUrl,
          account: account,
          nickname: name,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.buttonBlack),
                const SizedBox(height: 8),
                Text(account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack)
              ],
            ),
          ),
        ),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(4, 4)), color: AppColors.lightGreen5),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
              child: Text(toOrFromText, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            )),
      ],
    );
  }
}
