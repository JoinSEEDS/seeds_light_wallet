import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class ReceiveButton extends StatelessWidget {
  ReceiveButton({@required this.onPress});

  final GestureTapCallback onPress;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      onPressed: onPress,
      color: AppColors.springGreen,
      textColor: AppColors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(50),
      )),
      child: Center(
        child: Wrap(children: <Widget>[
          Icon(
            Icons.arrow_upward,
          ),
          Container(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text('Receive'.i18n, style: Theme.of(context).textTheme.button),
          ),
        ]),
      ),
    );
  }
}