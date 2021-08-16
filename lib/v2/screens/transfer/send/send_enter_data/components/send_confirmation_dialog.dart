import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/v2/screens/transfer/send/components/dialog_row.dart';

class SendConfirmationDialog extends StatelessWidget {
  final String amount;
  final String currency;
  final String? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;
  final VoidCallback onSendButtonPressed;

  const SendConfirmationDialog({
    Key? key,
    required this.currency,
    required this.amount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
    required this.onSendButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            "assets/images/transfer/seeds_icon.svg",
            height: 300,
            width: 300,
          ),
          Positioned(left: 12, bottom: -6, child: SvgPicture.asset("assets/images/transfer/arrow_up.svg")),
        ],
      ),
      onLeftButtonPressed: () => Navigator.of(context).pop(),
      onRightButtonPressed: () {
        onSendButtonPressed.call();
        Navigator.of(context).pop();
      },
      leftButtonTitle: "Edit".i18n,
      rightButtonTitle: "Send".i18n,
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
        DialogRow(imageUrl: toImage, account: toAccount, name: toName, toOrFromText: "To".i18n),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Network Fee".i18n, textAlign: TextAlign.left, style: Theme.of(context).textTheme.subtitle2),
            Text("Always Free and Instant!".i18n,
                textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
        const SizedBox(height: 40.0),
        if (memo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Memo".i18n, textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(memo!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
