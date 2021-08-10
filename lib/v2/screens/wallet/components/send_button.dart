import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPress;

  const SendButton({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      onPressed: onPress,
      color: AppColors.green1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Center(
        child: Wrap(
          children: <Widget>[
            const Icon(Icons.arrow_upward, color: AppColors.white),
            Container(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Text('Send'.i18n, style: Theme.of(context).textTheme.button),
            ),
          ],
        ),
      ),
    );
  }
}
