import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class ClaimUnplantSeedsBalanceRow extends StatelessWidget {
  final TokenDataModel? tokenAmount;
  final FiatDataModel? fiatAmount;
  final bool isClaimButtonEnable;
  final GestureTapCallback onTapClaim;

  const ClaimUnplantSeedsBalanceRow({
    super.key,
    required this.tokenAmount,
    required this.fiatAmount,
    required this.isClaimButtonEnable,
    required this.onTapClaim,
  });

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
                    child: Text('UnClaimed Balance',
                        style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
                        overflow: TextOverflow.ellipsis))),
            Container(
              height: 24,
              child: ElevatedButton(
                  onPressed: isClaimButtonEnable ? onTapClaim : null,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                      foregroundColor: AppColors.green1),
                  child: const Text("Claim", style: TextStyle(fontSize: 10))),
            ),
            const SizedBox(width: 10),
            Container(
                alignment: Alignment.centerRight,
                child: Text(tokenAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.subtitle1))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(fiatAmount?.asFormattedString() ?? "", style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
          ]),
        )
      ],
    );
  }
}
