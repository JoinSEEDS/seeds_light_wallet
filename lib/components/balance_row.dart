import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/models/amount_view_model.dart';
import 'package:seeds/design/app_theme.dart';

/// Available Amount
///
/// Used to show available amount or planted amount in a row together with Fiat Conversion
class BalanceRow extends StatelessWidget {
  final String label;
  final AmountViewModel tokenAmount;
  final AmountViewModel fiatAmount;

  const BalanceRow({
    Key? key,
    required this.label,
    required this.tokenAmount,
    required this.fiatAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(label, style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis))),
            Expanded(
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(tokenAmount.asFormattedString(), style: Theme.of(context).textTheme.subtitle1)))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(fiatAmount.asFormattedString(), style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
          ]),
        )
      ],
    );
  }
}
