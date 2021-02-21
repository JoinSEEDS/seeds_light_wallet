import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class ReceiveButton extends StatelessWidget {
  const ReceiveButton({@required this.onPress});

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      onPressed: onPress,
      color: AppColors.springGreen,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(50),
      )),
      child: Center(
        child: Wrap(children: <Widget>[
          const Icon(Icons.arrow_downward, color: AppColors.white),
          Container(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text('Receive'.i18n, style: Theme.of(context).textTheme.button),
          ),
        ]),
      ),
    );
  }
}
