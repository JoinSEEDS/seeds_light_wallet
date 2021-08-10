import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class SendTransactionSuccessDialog extends StatelessWidget {
  final String amount;
  final String currency;
  final String? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? fromImage;
  final String? fromName;
  final String fromAccount;
  final String transactionID;
  final VoidCallback onCloseButtonPressed;

  const SendTransactionSuccessDialog({
    Key? key,
    required this.amount,
    required this.currency,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.fromImage,
    this.fromName,
    required this.fromAccount,
    required this.transactionID,
    required this.onCloseButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          onSingleLargeButtonPressed: onCloseButtonPressed,
          singleLargeButtonTitle: 'Close',
          children: [
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount, style: Theme.of(context).textTheme.headline4),
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 4),
                  child: Text(currencySeedsCode, style: Theme.of(context).textTheme.subtitle2),
                ),
              ],
            ),
            Text(fiatAmount != null ? fiatAmount! : "", style: Theme.of(context).textTheme.subtitle2),
            const SizedBox(height: 30.0),
            DialogRow(imageUrl: toImage, account: toAccount, name: toName, toOrFromText: "To"),
            const SizedBox(height: 30.0),
            DialogRow(imageUrl: fromImage, account: fromAccount, name: fromName, toOrFromText: "From"),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text('Date:  ', style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(width: 16),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            Row(
              children: [
                Text('Transaction ID:  ', style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    transactionID,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  color: AppColors.lightGreen6,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: transactionID)).then(
                      (_) {
                        ScaffoldMessenger.maybeOf(context)!
                            .showSnackBar(const SnackBar(content: Text("Copied"), duration: Duration(seconds: 1)));
                      },
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Text('Status:  ', style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(width: 16),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.lightGreen6),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                    child: Text(
                      "Successful",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialogRow extends StatelessWidget {
  final String? imageUrl;
  final String account;
  final String? name;
  final String? toOrFromText;

  const DialogRow({Key? key, this.imageUrl, required this.account, this.name, this.toOrFromText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(size: 60, image: imageUrl, account: account, nickname: name),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name ?? account, textAlign: TextAlign.start, style: Theme.of(context).textTheme.button),
                const SizedBox(height: 8),
                Text(account, style: Theme.of(context).textTheme.subtitle2LowEmphasis)
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(4, 4)), color: AppColors.lightGreen6),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
            child: Text(toOrFromText!, style: Theme.of(context).textTheme.subtitle2),
          ),
        ),
      ],
    );
  }
}
