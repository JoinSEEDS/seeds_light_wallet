import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

class UnplantSeedsSuccessDialog extends StatelessWidget {
  final TokenDataModel unplantedInputAmount;
  final FiatDataModel unplantedInputAmountFiat;

  const UnplantSeedsSuccessDialog({
    super.key,
    required this.unplantedInputAmountFiat,
    required this.unplantedInputAmount,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
        singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
        onSingleLargeButtonPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                unplantedInputAmount.amountString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 4),
                child: Text(unplantedInputAmount.symbol, style: Theme.of(context).textTheme.titleSmall),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            unplantedInputAmountFiat.asFormattedString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 20.0),
          Text(context.loc.plantSeedsUnplantSuccessMessage,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20.0),
          Text(
            context.loc.plantSeedsUnplantExplanationMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
