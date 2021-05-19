

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';

class CurrencyInfoCard extends StatelessWidget {
  final String backgroundImage;
  final String title;
  final String logo;
  final String balanceSubTitle;
  final String balance;
  final String fiatBalance;
  final double? cardWidth;
  final double? cardHeight;
  final Color? textColor;

  const CurrencyInfoCard({
    Key? key,
    required this.balance,
    required this.backgroundImage,
    required this.title,
    required this.logo,
    required this.balanceSubTitle,
    required this.fiatBalance,
    this.cardWidth,
    this.cardHeight,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.fill)),
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      title,
                      style: Theme.of(context).textTheme.headline7.copyWith(color: textColor),
                    )),
                    Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: AssetImage(logo), fit: BoxFit.fill))),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(balanceSubTitle, style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor)),
                const SizedBox(
                  height: 6,
                ),
                Text(balance, style: Theme.of(context).textTheme.headline5!.copyWith(color: textColor)),
                const SizedBox(
                  height: 6,
                ),
                Text(fiatBalance, style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor))
              ],
            ),
          )
        ]));
  }
}
