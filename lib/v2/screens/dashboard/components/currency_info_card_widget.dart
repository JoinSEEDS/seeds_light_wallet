

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/dashboard/interactor/balance_bloc.dart';
import 'package:seeds/v2/dashboard/interactor/viewmodels/balance_event.dart';
import 'package:seeds/v2/dashboard/interactor/viewmodels/balance_state.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/datasource/local/models/token_model.dart';

class CurrencyInfoCardWidget extends StatelessWidget {
  final TokenModel token;
  final String backgroundImage;
  final String logo;
  final String balanceSubTitle;
  final double? cardWidth;
  final double? cardHeight;
  final Color? textColor;

  const CurrencyInfoCardWidget({
    Key? key,
    required this.token,
    required this.backgroundImage,
    required this.logo,
    required this.balanceSubTitle,
    this.cardWidth,
    this.cardHeight,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BalanceBloc>(
      create: (context) => BalanceBloc(token: token)..add(OnBalanceUpdate()),
      child: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) {
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
                            state.token.name,
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
                      Text("Balance", style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor)),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(state.displayString(), style: Theme.of(context).textTheme.headline5!.copyWith(color: textColor)),
                      const SizedBox(
                        height: 6,
                      ),
                      Text("", style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor))
                    ],
                  ),
                )
              ]));
        }
      ),
    );
  }
}
