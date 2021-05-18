import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';

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
      icon: SvgPicture.asset('assets/images/seeds_currency_icon.svg'),
      children: [
        Row(
          children: [
            Text(amount, style: Theme.of(context).textTheme.headline4Black),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Text(currency, style: Theme.of(context).textTheme.subtitle2Black),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Text(fiatAmount ?? "", style: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack),
        const SizedBox(height: 16.0),
        DialogRow(imageUrl: toImage, account: toAccount, name: toName, toOrFromText: "To"),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Network Fee",
                textAlign: TextAlign.left, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            Text("Always Free and Instant!",
                textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
          ],
        ),
        const SizedBox(height: 16.0),
        memo != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Memo",
                      textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
                  const SizedBox(width: 16.0),
                  Flexible(
                    child: Text(memo!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
      onLeftButtonPressed: () {
        Navigator.of(context).pop();
      },
      onRightButtonPressed: (){
        onSendButtonPressed.call();
        Navigator.of(context).pop();
      },
      leftButtonTitle: "Edit",
      rightButtonTitle: "Send",
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
              child: Text(toOrFromText!, style: Theme.of(context).textTheme.subtitle2BlackHighEmphasis),
            )),
      ],
    );
  }
}
