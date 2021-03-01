import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import '../read_times_tamp.dart';
import '../transaction_avatar.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/read_times_tamp.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/design/app_theme.dart';

class CurrencyInfoCard extends StatelessWidget {
  final String backgroundImage;
  final String title;
  final String logo;
  final String balanceSubTitle;
  final String balance;
  final String fiatBalance;
  final double cardWidth;
  final double cardHeight;

  const CurrencyInfoCard({
    Key key,
    @required this.balance,
    @required this.backgroundImage,
    @required this.title,
    @required this.logo,
    @required this.balanceSubTitle,
    @required this.fiatBalance,
     this.cardWidth,
     this.cardHeight,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.fill)),
        child: Stack(children: <Widget>[
          Positioned(
              top: 30,
              left: 20,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline7,
              )),
          Positioned(
              right: 20,
              top: 20,
              child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: AssetImage(logo), fit: BoxFit.fill)))),
          Positioned(left: 20, top: 110, child: Text(balanceSubTitle, style: Theme.of(context).textTheme.subtitle2)),
          Positioned(left: 20, bottom: 42, child: Text(balance, style: Theme.of(context).textTheme.headline5)),
          Positioned(left: 20, bottom: 20, child: Text(fiatBalance, style: Theme.of(context).textTheme.subtitle2))
        ]));
  }
}
