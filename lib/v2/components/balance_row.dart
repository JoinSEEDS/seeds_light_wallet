import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

/// Available Amount
///
/// Used to show available amount or planted amount in a row together with Fiat Conversion
class BalanceRow extends StatelessWidget {
  final String label;
  final String seedsAmount;
  final String fiatAmount;

  const BalanceRow({
    required this.label,
    required this.seedsAmount,
    required this.fiatAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child:
                        Text(label, style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis))),
            Expanded(
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(seedsAmount, style: Theme.of(context).textTheme.subtitle1)))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text( "\$" + fiatAmount, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)]),
        )
      ],
    );
  }
}
