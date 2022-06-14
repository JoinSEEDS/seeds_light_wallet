import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SendConfirmationDialog extends StatelessWidget {
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final String? toImage;
  final String? toName;
  final String toAccount;
  final String? memo;
  final VoidCallback onSendButtonPressed;

  const SendConfirmationDialog({
    super.key,
    required this.tokenAmount,
    this.fiatAmount,
    this.toImage,
    this.toName,
    required this.toAccount,
    this.memo,
    required this.onSendButtonPressed,
  });

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
      onRightButtonPressed: () {
        onSendButtonPressed.call();
        Navigator.of(context).pop();
      },
      leftButtonTitle: context.loc.transferSendEditButtonTitle,
      rightButtonTitle: context.loc.transferSendSendButtonTitle,
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tokenAmount.amountString(), style: Theme.of(context).textTheme.headline4),
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 4),
              child: Text(tokenAmount.symbol, style: Theme.of(context).textTheme.subtitle2),
            ),
          ],
        ),
        Text(fiatAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.subtitle2),
        const SizedBox(height: 30.0),
        DialogRow(imageUrl: toImage, account: toAccount, name: toName, toOrFromText: context.loc.transferSendTo),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.loc.transferSendNetworkFee,
                textAlign: TextAlign.left, style: Theme.of(context).textTheme.subtitle2),
            Text(context.loc.transferSendFreeAndInstant,
                textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
        const SizedBox(height: 40.0),
        if (memo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.loc.transferSendMemo,
                  textAlign: TextAlign.right, style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(memo!,
                    maxLines: 5,
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

class DialogRow extends StatelessWidget {
  final String? imageUrl;
  final String account;
  final String? name;
  final String? toOrFromText;

  const DialogRow({super.key, this.imageUrl, required this.account, this.name, this.toOrFromText});

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
