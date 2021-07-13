import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';

class CurrencyInfoCardWidget extends StatelessWidget {
  final TokenBalanceViewModel tokenBalance;
  final double? cardWidth;
  final double? cardHeight;
  final Color? textColor;

  const CurrencyInfoCardWidget({
    Key? key,
    required this.tokenBalance,
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
            image: DecorationImage(image: AssetImage(tokenBalance.token.backgroundImage), fit: BoxFit.fill)),
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
                      tokenBalance.token.name,
                      style: Theme.of(context).textTheme.headline7.copyWith(color: textColor),
                    )),
                    Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: AssetImage(tokenBalance.token.logo), fit: BoxFit.fill))),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text("Balance", style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor)),
                const SizedBox(
                  height: 6,
                ),
                Text(tokenBalance.displayQuantity,
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: textColor)),
                const SizedBox(
                  height: 6,
                ),
                Text("", style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor))
              ],
            ),
          )
        ]));
  }
}
